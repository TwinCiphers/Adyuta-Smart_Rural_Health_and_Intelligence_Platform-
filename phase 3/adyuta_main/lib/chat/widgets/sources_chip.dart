import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/material.dart';

import '../models/chat_message.dart';

/// The passages an answer rests on.
///
/// A source with `source_url_recorded == false` says "URL not recorded" rather
/// than rendering a link — the knowledge base never invents a URL and neither
/// should the UI.
class SourcesChips extends StatelessWidget {
  const SourcesChips({super.key, required this.sources});

  final List<SourceRef> sources;

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) return const SizedBox.shrink();
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: sources.map((SourceRef s) {
          final String subtitle = s.urlRecorded && (s.url ?? '').isNotEmpty
              ? (s.url as String)
              : 'URL not recorded';
          return Tooltip(
            message: '${s.chunkId}\n$subtitle',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                // surfaceContainerHighest is M3-only; use surface for SDK 3.0.x
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.dividerColor),
              ),
              child: GlobalBhashiniText(
                s.label,
                style: theme.textTheme.labelSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
