import 'package:flutter/material.dart';

import '../config.dart';

/// Connection and routing options.
///
/// The route and force selectors are the heart of testing this API: switching
/// between `/rag/answer` and `/router/route`, and forcing online/offline, is how
/// the connectivity story becomes observable.
class SettingsSheet extends StatefulWidget {
  const SettingsSheet({super.key, required this.settings, required this.onApply});

  final AppSettings settings;
  final ValueChanged<AppSettings> onApply;

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  late final TextEditingController _baseUrl =
      TextEditingController(text: widget.settings.baseUrl);
  late final TextEditingController _topK =
      TextEditingController(text: '${widget.settings.topK}');
  late AskRoute _route = widget.settings.route;
  late ForceMode _force = widget.settings.force;
  late String? _domain = widget.settings.domain;
  late String? _locale = widget.settings.locale;
  late bool _speak = widget.settings.speakReplies;

  @override
  void dispose() {
    _baseUrl.dispose();
    _topK.dispose();
    super.dispose();
  }

  void _apply() {
    final AppSettings next = widget.settings
      ..baseUrl = _baseUrl.text.trim().isEmpty ? kDefaultBaseUrl : _baseUrl.text.trim()
      ..route = _route
      ..force = _force
      ..domain = _domain
      ..locale = _locale
      ..topK = (int.tryParse(_topK.text.trim()) ?? 5).clamp(1, 50)
      ..speakReplies = _speak;
    widget.onApply(next);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Connection & routing', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _baseUrl,
              decoration: const InputDecoration(
                labelText: 'API base URL',
                helperText: 'Default comes from --dart-define=ADYUTA_BASE_URL',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 14),

            Text('Endpoint', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            SegmentedButton<AskRoute>(
              segments: const <ButtonSegment<AskRoute>>[
                ButtonSegment<AskRoute>(
                  value: AskRoute.direct,
                  label: Text('/rag/answer'),
                  
                ),
                ButtonSegment<AskRoute>(
                  value: AskRoute.router,
                  label: Text('/router/route'),
                  
                ),
              ],
              selected: <AskRoute>{_route},
              onSelectionChanged: (Set<AskRoute> s) => setState(() => _route = s.first),
            ),
            const SizedBox(height: 14),

            Text('Connectivity (router only)', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            SegmentedButton<ForceMode>(
              segments: const <ButtonSegment<ForceMode>>[
                ButtonSegment<ForceMode>(value: ForceMode.auto, label: Text('auto')),
                ButtonSegment<ForceMode>(value: ForceMode.online, label: Text('online')),
                ButtonSegment<ForceMode>(value: ForceMode.offline, label: Text('offline')),
              ],
              selected: <ForceMode>{_force},
              onSelectionChanged: (Set<ForceMode> s) => setState(() => _force = s.first),
            ),
            if (_force == ForceMode.offline && _route == AskRoute.router)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Offline routing answers from the local templates and queues the '
                  'query in local-models/mobile/queue.jsonl on the server.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.orange),
                ),
              ),
            const SizedBox(height: 14),

            Text('Question language (router only)',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            DropdownButtonFormField<String?>(
              value: _locale,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                helperMaxLines: 3,
                helperText: 'Not a translation. Tier 1 (en/kn/hi/ta) has '
                    'advisories; tier 2 (te/bn/gu/pa/ml) is detected but '
                    'answered in English; tier 3 has no detection.',
              ),
              items: <DropdownMenuItem<String?>>[
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('auto (detect from the text)'),
                ),
                ...kLocales.map((String l) => DropdownMenuItem<String?>(
                      value: l,
                      child: Text(l),
                    )),
              ],
              onChanged: (String? v) => setState(() => _locale = v),
            ),
            const SizedBox(height: 14),

            Text('Domain filter', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              children: <Widget>[
                ChoiceChip(
                  label: const Text('any'),
                  selected: _domain == null,
                  onSelected: (_) => setState(() => _domain = null),
                ),
                ...kDomains.map((String d) => ChoiceChip(
                      label: Text(d),
                      selected: _domain == d,
                      onSelected: (_) => setState(() => _domain = d),
                    )),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              children: <Widget>[
                SizedBox(
                  width: 110,
                  child: TextField(
                    controller: _topK,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'top_k',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _speak,
                    onChanged: (bool v) => setState(() => _speak = v),
                    title: const Text('Read answers aloud'),
                    subtitle: const Text('Device voice, not the backend'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _apply, child: const Text('Apply')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
