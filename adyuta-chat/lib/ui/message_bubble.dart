import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/chat_message.dart';
import '../widgets/meta_row.dart';
import '../widgets/sources_chip.dart';

/// One turn in the conversation.
///
/// The four outcomes render visibly differently on purpose: an abstention, a
/// placeholder and a failure must never look like an answer.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.onSpeak,
    this.onShowRaw,
    this.isSpeaking = false,
  });

  final ChatMessage message;
  final VoidCallback? onSpeak;
  final VoidCallback? onShowRaw;
  final bool isSpeaking;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isUser = message.isUser;

    final (Color bg, Color fg, IconData? icon, String? headline) = switch (message.kind) {
      MessageKind.answered => (
          theme.colorScheme.surfaceVariant,
          theme.colorScheme.onSurface,
          null,
          null,
        ),
      MessageKind.deviceTranscript => (
          theme.colorScheme.surfaceVariant,
          theme.colorScheme.onSurface,
          Icons.mic_none,
          'Device-supplied transcript — not server speech recognition',
        ),
      MessageKind.declined => (
          Colors.orange.withOpacity(0.12),
          theme.colorScheme.onSurface,
          Icons.search_off,
          'No answer — nothing cleared the relevance floor, so no model ran',
        ),
      MessageKind.abstained => (
          Colors.orange.withOpacity(0.12),
          theme.colorScheme.onSurface,
          Icons.search_off,
          'No relevant information found',
        ),
      MessageKind.placeholder => (
          Colors.orange.withOpacity(0.16),
          theme.colorScheme.onSurface,
          Icons.power_off,
          'No model connected — this is not an answer',
        ),
      MessageKind.failed => (
          Colors.red.withOpacity(0.12),
          theme.colorScheme.onSurface,
          Icons.error_outline,
          'Request failed',
        ),
    };

    // A refusal from the server is shown as the server wrote it, with its own
    // headline, rather than replaced by a client-side notice.
    final bool showNotice = !isUser &&
        message.kind != MessageKind.answered &&
        message.kind != MessageKind.declined;

    final String displayText = showNotice 
        ? message.notice 
        : message.text.replaceAll(RegExp(r'【.*?】|\[ADY-.*?\]'), '');

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 720),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        decoration: BoxDecoration(
          color: isUser 
              ? theme.colorScheme.primaryContainer 
              : (message.kind == MessageKind.answered ? theme.colorScheme.surface : bg),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (headline != null)
              Row(
                children: <Widget>[
                  if (icon != null) ...<Widget>[
                    Icon(icon, size: 16, color: Colors.orange),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      headline,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: message.kind == MessageKind.failed
                            ? Colors.red
                            : (message.kind == MessageKind.answered ? null : Colors.orange),
                      ),
                    ),
                  ),
                ],
              ),
            if (headline != null) const SizedBox(height: 6),

            MarkdownBody(
              data: displayText,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: theme.textTheme.bodyMedium?.copyWith(
                  color: isUser ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                  fontSize: 16,
                  height: 1.5,
                ),
                h1: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.4),
                h2: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, height: 1.4),
                h3: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, height: 1.4),
                h4: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.4),
                h5: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, height: 1.4),
                h6: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, height: 1.4),
                listBullet: theme.textTheme.bodyMedium?.copyWith(
                  color: isUser ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                  fontSize: 16, 
                  height: 1.5,
                ),
                code: theme.textTheme.bodySmall?.copyWith(
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
                codeblockDecoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                blockquoteDecoration: BoxDecoration(
                  border: Border(left: BorderSide(color: theme.colorScheme.primary, width: 4)),
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                ),
                blockquotePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),

            if (!isUser && message.meta != null) ...<Widget>[
              const SizedBox(height: 4),
              MetaRow(meta: message.meta!, answerText: message.text),
              SourcesChips(sources: message.meta!.sources),
            ],

            if (!isUser)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (onSpeak != null)
                    IconButton(
                      tooltip: isSpeaking ? 'Stop speaking' : 'Read aloud (device voice)',
                      iconSize: 18,
                      visualDensity: VisualDensity.compact,
                      onPressed: onSpeak,
                      icon: Icon(isSpeaking ? Icons.stop_circle : Icons.volume_up_outlined),
                    ),
                  if (onShowRaw != null)
                    IconButton(
                      tooltip: 'Show the raw server response',
                      iconSize: 18,
                      visualDensity: VisualDensity.compact,
                      onPressed: onShowRaw,
                      icon: const Icon(Icons.data_object),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
