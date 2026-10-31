import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
// `Placeholder` is hidden from Material because this app's own `ChatOutcome`
// case of that name is the one the UI must branch on; Flutter's placeholder
// widget is never used here.
import 'package:flutter/material.dart' hide Placeholder;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';

import '../api/adyuta_client.dart';
import '../api/outcome.dart';
import '../config.dart';
import '../models/chat_message.dart';
import '../models/conversation.dart';
import '../store/conversation_store.dart';
import '../utils/file_reader.dart';
import 'history_drawer.dart';
import 'message_bubble.dart';
import 'settings_sheet.dart';

/// Suggested questions, chosen to exercise the interesting paths rather than to
/// look impressive: a grounded answer, a sparse-domain answer, an abstention and
/// a safety reply that must be static.
const List<String> _suggestions = <String>[
  'How do I control early blight in tomato?',
  'What is PM-KISAN and who is eligible?',
  'who won the cricket match yesterday',
  'first aid for a snake bite',
];

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AdyutaClient _client = AdyutaClient();
  final ConversationStore _store = ConversationStore();
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final AudioRecorder _recorder = AudioRecorder();
  final FlutterTts _tts = FlutterTts();

  AppSettings _settings = AppSettings();
  List<Conversation> _conversations = <Conversation>[];
  Conversation? _active;
  ServiceStatus? _status;

  bool _booting = true;
  bool _busy = false;
  bool _recording = false;
  bool _isLiveVoiceMode = false;
  String? _speakingId;

  /// Raw server responses for the current session only. They are deliberately
  /// not persisted: `context` and `selected_chunks` make every reply large, and
  /// a stale dump would be worse than none.
  final Map<String, Map<String, dynamic>> _rawById = <String, Map<String, dynamic>>{};

  @override
  void initState() {
    super.initState();
    _boot();
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _boot() async {
    final AppSettings settings = await AppSettings.load();
    final List<Conversation> saved = await _store.load();
    if (!mounted) return;
    setState(() {
      _settings = settings;
      _conversations = saved;
      _active = saved.isNotEmpty ? saved.first : _newConversation(activate: false);
      _booting = false;
    });
    _scrollToEnd();
    await _refreshStatus();
  }

  Conversation _newConversation({bool activate = true}) {
    final DateTime now = DateTime.now();
    final Conversation c = Conversation(
      id: 'c${now.microsecondsSinceEpoch}',
      title: '',
      createdAt: now,
      updatedAt: now,
    );
    if (activate) _active = c;
    return c;
  }

  String get _sessionId => _active?.id ?? 'console';

  Future<void> _refreshStatus() async {
    final ServiceStatus s = await _client.status(_settings);
    if (!mounted) return;
    setState(() => _status = s);
  }

  /// Pins the list to the newest turn.
  ///
  /// Called on send, and also whenever a saved conversation is shown: without
  /// it a reopened chat opens at its first message, which hides the answer the
  /// user came back for. The jump is retried on the following frame because a
  /// freshly laid-out list can still be growing its extent (wrapping chips,
  /// multi-line answers), which would otherwise leave it a little short.
  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scroll.hasClients) return;
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      });
    });
  }

  Future<void> _persist() async {
    final Conversation? active = _active;
    if (active == null) return;
    active.maybeRetitle();
    active.touch();
    final List<Conversation> next = <Conversation>[
      active,
      ..._conversations.where((Conversation c) => c.id != active.id),
    ];
    _conversations = next;
    await _store.saveAll(next);
  }

  /// Prior turns as the caller-held `history`. The API ignores it when the
  /// session already holds turns, so sending both is harmless and means a
  /// follow-up still has context after the server forgets the session.
  List<ChatTurn> _historyFor(Conversation c) {
    const int maxTurns = 6;
    // The caller has already appended the turn being sent, so it is excluded.
    final List<ChatMessage> prior = c.messages.length <= 1
        ? const <ChatMessage>[]
        : c.messages.sublist(0, c.messages.length - 1);
    final List<ChatMessage> tail =
        prior.length <= maxTurns ? prior : prior.sublist(prior.length - maxTurns);

    final List<ChatTurn> out = <ChatTurn>[];
    for (final ChatMessage m in tail) {
      final String raw = m.isUser
          ? m.text
          : (m.kind == MessageKind.answered || m.kind == MessageKind.declined
              ? m.text
              : m.notice);
      final String content = raw.trim();
      if (content.isEmpty) continue;
      out.add(ChatTurn(
        role: m.isUser ? 'user' : 'assistant',
        content: content.length > 4000 ? content.substring(0, 4000) : content,
      ));
    }
    return out;
  }

  MessageKind _kindOf(ChatOutcome outcome) => switch (outcome) {
        Answered() => MessageKind.answered,
        Declined() => MessageKind.declined,
        Abstained() => MessageKind.abstained,
        Placeholder() => MessageKind.placeholder,
        Failed() => MessageKind.failed,
        DeviceTranscript() => MessageKind.deviceTranscript,
      };

  ChatMessage _assistantMessage(String id, Reply reply) => ChatMessage(
        id: id,
        role: ChatRole.assistant,
        text: reply.storedText,
        at: DateTime.now(),
        kind: _kindOf(reply.outcome),
        notice: reply.outcome.notice,
        meta: reply.meta,
      );

  Future<void> _send([String? preset]) async {
    _isLiveVoiceMode = false;
    final String text = (preset ?? _input.text).trim();
    final Conversation? active = _active;
    if (text.isEmpty || _busy || active == null) return;

    final DateTime now = DateTime.now();
    active.messages.add(ChatMessage(
      id: 'u${now.microsecondsSinceEpoch}',
      role: ChatRole.user,
      text: text,
      at: now,
    ));
    _input.clear();
    setState(() => _busy = true);
    _scrollToEnd();

    final List<ChatTurn> history = _historyFor(active);
    final Reply reply = await _client.ask(
      settings: _settings,
      query: text,
      sessionId: _sessionId,
      history: history,
    );
    if (!mounted) return;

    final ChatMessage assistant =
        _assistantMessage('a${DateTime.now().microsecondsSinceEpoch}', reply);
    setState(() {
      active.messages.add(assistant);
      _rawById[assistant.id] = reply.raw;
      _busy = false;
    });
    _scrollToEnd();
    await _persist();

    if (_settings.speakReplies && reply.outcome.displayText != null) {
      await _speak(assistant.id, reply.outcome.displayText!);
    }
  }

  Future<void> _toggleRecording() async {
    if (_speakingId != null) {
      await _tts.stop();
      setState(() => _speakingId = null);
    }
    if (_busy) return;
    if (_recording) {
      await _stopAndSendVoice();
      return;
    }
    try {
      final bool allowed = await _recorder.hasPermission();
      if (!mounted) return;
      if (!allowed) {
        _snack('Microphone permission was denied. Type the question instead — '
            'the app will not pretend a typed text was speech.');
        return;
      }
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.opus),
        path: kIsWeb 
            ? 'adyuta_voice.webm' 
            : '/data/data/com.example.adyuta_chat/cache/adyuta_voice.webm',
      );
      if (!mounted) return;
      setState(() => _recording = true);
    } catch (e) {
      if (!mounted) return;
      _snack('Could not start recording: $e');
    }
  }

  Future<void> _stopAndSendVoice() async {
    final Conversation? active = _active;
    if (active == null) return;
    try {
      final String? path = await _recorder.stop();
      if (!mounted) return;
      _isLiveVoiceMode = true;
      setState(() {
        _recording = false;
        _busy = true;
      });
      if (path == null) {
        setState(() => _busy = false);
        _snack('The recorder returned no audio.');
        return;
      }

      final Uint8List? bytes = await _readRecording(path);
      if (bytes == null || bytes.isEmpty) {
        if (!mounted) return;
        setState(() => _busy = false);
        _snack(kIsWeb
            ? 'The recording came back empty.'
            : 'Reading recorded audio from disk is not wired up in this build; '
                'run the web target or extend _readRecording.');
        return;
      }

      final ChatMessage userMsg = ChatMessage(
        id: 'u${DateTime.now().microsecondsSinceEpoch}',
        role: ChatRole.user,
        text: '(voice question)',
        at: DateTime.now(),
      );
      active.messages.add(userMsg);
      setState(() {});
      _scrollToEnd();

      final Reply reply = await _client.askVoice(
        settings: _settings,
        audioBytes: bytes,
        filename: 'adyuta_voice.webm',
      );
      if (!mounted) return;

      // Show what the server actually heard, so the transcript is auditable
      // rather than assumed.
      final String? heard = reply.meta.transcript;
      final ChatMessage assistant =
          _assistantMessage('a${DateTime.now().microsecondsSinceEpoch}', reply);
      setState(() {
        _replaceText(
          userMsg.id,
          heard != null && heard.isNotEmpty ? '🎤 $heard' : '🎤 (voice question)',
        );
        active.messages.add(assistant);
        _rawById[assistant.id] = reply.raw;
        _busy = false;
      });
      _scrollToEnd();
      await _persist();
      
      if (_settings.speakReplies && reply.outcome.displayText != null) {
        await _speak(assistant.id, reply.outcome.displayText!);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _recording = false;
        _busy = false;
      });
    }
  }

  /// `text` on a [ChatMessage] is final, so a voice turn is rewritten by
  /// replacing the entry rather than mutating it.
  void _replaceText(String id, String text) {
    final List<ChatMessage>? msgs = _active?.messages;
    if (msgs == null) return;
    final int i = msgs.indexWhere((ChatMessage m) => m.id == id);
    if (i < 0) return;
    final ChatMessage old = msgs[i];
    msgs[i] = ChatMessage(
      id: old.id,
      role: old.role,
      text: text,
      at: old.at,
      kind: old.kind,
      notice: old.notice,
      meta: old.meta,
    );
  }

  /// On web the recorder hands back a blob URL; elsewhere a file path, which
  /// this build does not read (see the message in [_stopAndSendVoice]).
  Future<Uint8List?> _readRecording(String path) async {
    try {
      if (path.startsWith('blob:') || path.startsWith('http')) {
        final http.Response res = await http.get(Uri.parse(path));
        return res.bodyBytes;
      }
      return await readLocalFile(path);
    } catch (_) {
      return null;
    }
  }

  Future<void> _speak(String id, String text) async {
    try {
      if (_speakingId == id) {
        await _tts.stop();
        _isLiveVoiceMode = false;
        if (mounted) setState(() => _speakingId = null);
        return;
      }
      
      // Clean markdown syntax for TTS
      String cleanText = text
          .replaceAll(RegExp(r'【.*?】'), '') // remove citations
          .replaceAll(RegExp(r'\[.*?\]'), '') // remove normal brackets too
          .replaceAll(RegExp(r'[*#`_~>]'), '')
          .replaceAll(RegExp(r'^\s*-\s+', multiLine: true), '') // bullet points
          .replaceAll(RegExp(r'-{2,}'), '') // markdown table dash lines
          .replaceAll('|', ' ') // table pipes
          .trim();
          
      if (mounted) setState(() => _speakingId = id);
      
      String lang = 'en-IN';
      if (cleanText.contains(RegExp(r'[\u0900-\u097F]'))) {
        lang = 'hi-IN'; // Hindi
      } else if (cleanText.contains(RegExp(r'[\u0C80-\u0CFF]'))) {
        lang = 'kn-IN'; // Kannada
      } else if (cleanText.contains(RegExp(r'[\u0B80-\u0BFF]'))) {
        lang = 'ta-IN'; // Tamil
      }
      
      await _tts.setLanguage(lang);
      _tts.setCompletionHandler(() {
        if (mounted && _speakingId == id) {
          setState(() => _speakingId = null);
          if (_isLiveVoiceMode && !_busy && !_recording) {
            _toggleRecording();
          }
        }
      });
      await _tts.speak(cleanText);
    } catch (_) {
      if (mounted) _snack('Device text-to-speech is unavailable in this browser.');
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showRaw(ChatMessage message) {
    final Map<String, dynamic>? raw = _rawById[message.id];
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Raw server response'),
        content: SizedBox(
          width: 720,
          child: SingleChildScrollView(
            child: SelectableText(
              raw == null
                  ? 'Raw JSON is kept for the current session only, so the '
                      'response for this turn is no longer in memory.'
                  : const JsonEncoder.withIndent('  ').convert(raw),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _openSettings() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) => SettingsSheet(
        settings: _settings,
        onApply: (AppSettings next) {
          setState(() => _settings = next);
          next.save();
          _refreshStatus();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Conversation? active = _active;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ADYUTA chat', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh server status',
            onPressed: _refreshStatus,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Connection & routing',
            onPressed: _openSettings,
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      drawer: HistoryDrawer(
        conversations: _conversations,
        activeId: active?.id,
        onNew: () {
          Navigator.of(context).pop();
          setState(() => _newConversation());
        },
        onOpen: (Conversation c) {
          Navigator.of(context).pop();
          setState(() => _active = c);
          _scrollToEnd();
        },
        onDelete: (Conversation c) async {
          Navigator.of(context).pop();
          final List<Conversation> next =
              _conversations.where((Conversation x) => x.id != c.id).toList();
          setState(() {
            _conversations = next;
            if (_active?.id == c.id) {
              _active = next.isNotEmpty ? next.first : _newConversation(activate: false);
            }
          });
          await _store.saveAll(next);
        },
      ),
      body: _booting
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                _StatusStrip(
                  status: _status,
                  settings: _settings,
                  onSettings: _openSettings,
                ),
                if (active != null && active.messages.isEmpty)
                  Expanded(child: _EmptyState(onPick: _send)),
                if (active != null && active.messages.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      controller: _scroll,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: active.messages.length,
                      itemBuilder: (BuildContext context, int i) {
                        final ChatMessage m = active.messages[i];
                        return MessageBubble(
                          message: m,
                          isSpeaking: _speakingId == m.id,
                          onSpeak: m.isUser || m.kind != MessageKind.answered
                              ? null
                              : () => _speak(m.id, m.text),
                          onShowRaw: m.isUser ? null : () => _showRaw(m),
                        );
                      },
                    ),
                  ),
                if (_busy) const LinearProgressIndicator(minHeight: 2),
                _Composer(
                  controller: _input,
                  busy: _busy,
                  recording: _recording,
                  onSend: _send,
                  onMic: _toggleRecording,
                ),
              ],
            ),
    );
  }
}

class _StatusStrip extends StatelessWidget {
  const _StatusStrip({
    required this.status,
    required this.settings,
    required this.onSettings,
  });

  final ServiceStatus? status;
  final AppSettings settings;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ServiceStatus? s = status;

    final String text;
    if (s == null) {
      text = 'checking the server…';
    } else if (!s.reachable) {
      text = 'unreachable at ${settings.baseUrl} — start the API and check CORS';
    } else {
      final List<String> parts = <String>[
        'adapter: ${s.adapter ?? 'unknown'}',
        if (s.online != null) 'internet: ${s.online! ? 'yes' : 'no'}',
        if (s.vectors != null) 'vectors: ${s.vectors}',
        if (s.cropAccuracy != null)
          'crop model: ${(s.cropAccuracy! * 100).toStringAsFixed(2)}%',
      ];
      text = parts.join('  ·  ');
    }

    final bool bad = s != null && !s.reachable;
    return Container(
      width: double.infinity,
      color: bad ? Colors.red.withOpacity(0.12) : theme.colorScheme.surfaceVariant,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onSettings,
        child: Row(
          children: <Widget>[
            Icon(bad ? Icons.cloud_off : Icons.dns_outlined, size: 14),
            const SizedBox(width: 6),
            Expanded(
              child: Text(text, style: theme.textTheme.labelSmall),
            ),
            Text(
              settings.route == AskRoute.router
                  ? '/router/route · ${forceModeName(settings.force)}'
                  : '/rag/answer',
              style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onPick});

  final void Function(String) onPick;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Ask the ADYUTA backend', style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Answers are grounded in the knowledge base. When nothing relevant '
            'is found the server abstains, and if no model is connected you will '
            'see that stated instead of a fabricated answer.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestions
                .map((String q) => ActionChip(
                      label: Text(q),
                      onPressed: () => onPick(q),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.busy,
    required this.recording,
    required this.onSend,
    required this.onMic,
  });

  final TextEditingController controller;
  final bool busy;
  final bool recording;
  final void Function([String?]) onSend;
  final VoidCallback onMic;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            IconButton(
              tooltip: recording ? 'Stop and send' : 'Ask by voice',
              onPressed: busy ? null : onMic,
              icon: Icon(recording ? Icons.stop_circle : Icons.mic_none,
                  color: recording ? Colors.red : null),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Message Adyuta...',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: busy ? null : () => onSend(),
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
