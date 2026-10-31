import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/conversation.dart';

/// Saved conversations.
///
/// Each conversation's id is also its server `session_id`, so re-opening one
/// keeps follow-up questions working while the server still remembers the
/// session — and still works when it does not, because the display history is
/// local.
class HistoryDrawer extends StatelessWidget {
  const HistoryDrawer({
    super.key,
    required this.conversations,
    required this.activeId,
    required this.onNew,
    required this.onOpen,
    required this.onDelete,
  });

  final List<Conversation> conversations;
  final String? activeId;
  final VoidCallback onNew;
  final ValueChanged<Conversation> onOpen;
  final ValueChanged<Conversation> onDelete;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Chats', style: theme.textTheme.titleMedium),
                  ),
                  IconButton(
                    tooltip: 'New chat',
                    onPressed: onNew,
                    icon: const Icon(Icons.add_comment_outlined),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: conversations.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'No saved chats yet. Ask something and it will appear here.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: conversations.length,
                      itemBuilder: (BuildContext context, int i) {
                        final Conversation c = conversations[i];
                        final bool active = c.id == activeId;
                        return ListTile(
                          selected: active,
                          leading: const Icon(Icons.chat_bubble_outline, size: 18),
                          title: Text(
                            c.title.isEmpty ? 'New chat' : c.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${c.messages.length} messages · '
                            '${DateFormat('d MMM, HH:mm').format(c.updatedAt)}',
                            style: theme.textTheme.labelSmall,
                          ),
                          trailing: IconButton(
                            tooltip: 'Delete',
                            iconSize: 18,
                            onPressed: () => onDelete(c),
                            icon: const Icon(Icons.delete_outline),
                          ),
                          onTap: () => onOpen(c),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
