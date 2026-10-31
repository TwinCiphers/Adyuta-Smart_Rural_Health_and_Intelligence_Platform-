import 'package:flutter/material.dart';
import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.onSpeak,
    this.isSpeaking = false,
  });

  final ChatMessage message;
  final VoidCallback? onSpeak;
  final bool isSpeaking;

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;
    final sources = message.meta?.sources ?? [];
    final bool hasSources = message.text.contains("DOCUMENT EXCERPT") || sources.isNotEmpty;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) 
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundImage: AssetImage('assets/images/aroha_logo.png'),
                  ),
                ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? const Color(0xFF3366FF) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                    ],
                  ),
                  child: MarkdownBody(
                    data: message.text,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 15, height: 1.4),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(left: 36.0, top: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(isSpeaking ? Icons.volume_up : Icons.volume_mute, size: 18, color: isSpeaking ? const Color(0xFF3366FF) : Colors.grey.shade500),
                    onPressed: onSpeak,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(Icons.copy, size: 16, color: Colors.grey.shade500),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: message.text));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: GlobalBhashiniText('Copied to clipboard')));
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  if (hasSources)
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const GlobalBhashiniText('Sources Used'),
                            content: SingleChildScrollView(
                              child: GlobalBhashiniText(
                                sources.isEmpty ? 'Offline SchemeSaathi Database & Governance Documents' : sources.map((s) => s.label).join('\n\n'),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const GlobalBhashiniText('Close'))],
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.library_books, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          GlobalBhashiniText('Sources', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
