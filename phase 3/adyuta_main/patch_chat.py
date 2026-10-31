import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart' show Record, AudioEncoder;
import 'package:path_provider/path_provider.dart';

import '../api/groq_service.dart';
import '../models/chat_message.dart';
import '../models/conversation.dart';
import '../store/conversation_store.dart';
import 'message_bubble.dart';
import 'history_drawer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ConversationStore _store = ConversationStore();
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final Record _recorder = Record();
  final FlutterTts _tts = FlutterTts();

  List<Conversation> _conversations = [];
  Conversation? _active;

  bool _booting = true;
  bool _busy = false;
  bool _recording = false;
  String? _speakingId;
  String? _base64Image;

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
    final List<Conversation> saved = await _store.load();
    if (!mounted) return;
    setState(() {
      _conversations = saved;
      _active = saved.isNotEmpty ? saved.first : _newConversation(activate: false);
      _booting = false;
      
      if (_active != null && _active!.messages.isEmpty) {
        _active!.messages.add(
          ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            role: ChatRole.assistant,
            text: "Hi, I am Aroha! How can I help you today?",
            at: DateTime.now(),
            kind: MessageKind.answered,
            meta: const MessageMeta(),
          ),
        );
      }
    });
    _scrollToEnd();
  }

  Conversation _newConversation({bool activate = true}) {
    final DateTime now = DateTime.now();
    final Conversation c = Conversation(
      id: 'c-\',
      title: 'New Chat',
      createdAt: now,
      updatedAt: now,
    );
    if (activate) {
      setState(() {
        _conversations = [c, ..._conversations];
        _active = c;
      });
      _store.saveAll(_conversations);
    }
    return c;
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _speak(String id, String text) async {
    if (_speakingId == id) {
      await _tts.stop();
      if (!mounted) return;
      setState(() => _speakingId = null);
      return;
    }
    await _tts.stop();
    if (!mounted) return;
    setState(() => _speakingId = id);
    _tts.setCompletionHandler(() {
      if (mounted && _speakingId == id) setState(() => _speakingId = null);
    });
    
    await _tts.setLanguage("en-IN");
    await _tts.speak(text.replaceAll(RegExp(r'\*\*|\*'), '')); 
  }

  Future<void> _toggleRecording() async {
    if (_recording) {
      final String? path = await _recorder.stop();
      setState(() => _recording = false);
      if (path != null) {
        _sendVoice(path);
      }
    } else {
      if (await _recorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final String path = '\/mic.m4a';
        await _recorder.start(
          path: path,
          encoder: AudioEncoder.aacLc,
        );
        setState(() => _recording = true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Microphone permission denied.')));
      }
    }
  }

  Future<void> _sendVoice(String filePath) async {
    setState(() => _busy = true);
    try {
      final bytes = await File(filePath).readAsBytes();
      final text = await GroqService.transcribeAudio(bytes, 'mic.m4a');
      if (text.trim().isNotEmpty) {
        _input.text = text;
        _send();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Voice STT error: \')));
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
      _send("Please analyze this image.");
    }
  }

  Future<void> _pickDocument() async {
    // For now, mock document as we'd need file_picker plugin
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Document parsing coming soon...')));
  }

  Future<void> _send([String? overrideText]) async {
    final String text = overrideText ?? _input.text.trim();
    if (text.isEmpty && _base64Image == null) return;
    
    final Conversation c = _active ?? _newConversation();
    if (!_conversations.any((Conversation x) => x.id == c.id)) {
      _conversations = [c, ..._conversations];
    }
    
    final String img = _base64Image ?? '';
    _input.clear();
    setState(() {
      _base64Image = null;
      c.messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: ChatRole.user,
          text: img.isNotEmpty ? "[Image Attached] \" : text,
          at: DateTime.now(),
          kind: MessageKind.answered,
          meta: const MessageMeta(),
        ),
      );
      _busy = true;
    });
    _scrollToEnd();
    await _store.saveAll(_conversations);

    try {
      final history = c.messages.where((m) => !m.text.contains('[Image Attached]')).map((m) => {
        "role": m.isUser ? "user" : "assistant",
        "content": m.text
      }).toList();
      
      if (history.length > 6) history.removeRange(0, history.length - 6);
      
      final replyText = await GroqService.askGroq(
        text,
        history: history,
        base64Image: img.isNotEmpty ? img : null,
      );
      
      setState(() {
        c.messages.add(
          ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            role: ChatRole.assistant,
            text: replyText,
            at: DateTime.now(),
            kind: MessageKind.answered,
            meta: const MessageMeta(sources: []),
          ),
        );
        _busy = false;
      });
    } catch (e) {
      setState(() {
        c.messages.add(
          ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            role: ChatRole.assistant,
            text: 'I encountered an error connecting to my neural core. Please try again. (\)',
            at: DateTime.now(),
            kind: MessageKind.failed,
            meta: const MessageMeta(),
          ),
        );
        _busy = false;
      });
    }
    _scrollToEnd();
    await _store.saveAll(_conversations);
  }

  void _onSwitchConversation(Conversation c) {
    setState(() => _active = c);
    _scrollToEnd();
    Navigator.pop(context); // Close drawer
  }

  void _onDeleteConversation(Conversation c) async {
    final List<Conversation> next = _conversations.where((x) => x.id != c.id).toList();
    setState(() {
      _conversations = next;
      if (_active?.id == c.id) {
        _active = next.isNotEmpty ? next.first : _newConversation(activate: false);
      }
    });
    await _store.saveAll(next);
  }

  @override
  Widget build(BuildContext context) {
    final Conversation? active = _active;
    return Scaffold(
      drawer: HistoryDrawer(
        activeId: _active?.id,
        conversations: _conversations,
        onSwitch: _onSwitchConversation,
        onDelete: _onDeleteConversation,
        onNewChat: () {
          _newConversation();
          Navigator.pop(context);
        },
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/aroha_logo.png', height: 28),
            const SizedBox(width: 8),
            const Text('Aroha AI', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: () {
              final Conversation c = _newConversation();
              _store.saveAll(_conversations);
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF8F9FA),
        child: _booting
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  if (active != null && active.messages.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.only(top: 16, bottom: 24),
                        itemCount: active.messages.length,
                        itemBuilder: (BuildContext context, int i) {
                          final ChatMessage m = active.messages[i];
                          return MessageBubble(
                            message: m,
                            isSpeaking: _speakingId == m.id,
                            onSpeak: m.isUser ? null : () => _speak(m.id, m.text),
                          );
                        },
                      ),
                    ),
                  if (_busy) const LinearProgressIndicator(minHeight: 2, color: Color(0xFF3366FF)),
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 12, 12, 16),
                    color: Colors.white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.add_circle_outline, color: Color(0xFF3366FF), size: 28),
                          offset: const Offset(0, -120),
                          onSelected: (value) {
                            if (value == 'camera') _pickImage(ImageSource.camera);
                            if (value == 'gallery') _pickImage(ImageSource.gallery);
                            if (value == 'doc') _pickDocument();
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'camera',
                              child: Row(
                                children: [Icon(Icons.camera_alt_outlined), SizedBox(width: 8), Text('Camera')],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'gallery',
                              child: Row(
                                children: [Icon(Icons.photo_library_outlined), SizedBox(width: 8), Text('Photos')],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'doc',
                              child: Row(
                                children: [Icon(Icons.insert_drive_file_outlined), SizedBox(width: 8), Text('Document')],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _input,
                                    maxLines: 4,
                                    minLines: 1,
                                    decoration: const InputDecoration(
                                      hintText: 'Message Aroha...',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    ),
                                    onSubmitted: (_) => _send(),
                                  ),
                                ),
                                IconButton(
                                  onPressed: _busy ? null : _toggleRecording,
                                  icon: Icon(
                                    _recording ? Icons.stop_circle : Icons.mic_none,
                                    color: _recording ? Colors.red : const Color(0xFF3366FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF3366FF),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: _busy ? null : () => _send(),
                            icon: const Icon(Icons.send, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
