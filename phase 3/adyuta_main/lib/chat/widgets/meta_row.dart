import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/material.dart';

import '../models/chat_message.dart';

/// The small print under an answer: which model replied, how it was routed, how
/// well grounded it was, and whether the answer is thin.
///
/// Every value here is reported by the server. Nothing is inferred, and a value
/// the server did not send is simply absent rather than guessed.
class MetaRow extends StatelessWidget {
  const MetaRow({super.key, required this.meta, this.answerText = ''});

  final MessageMeta meta;

  /// The answer body, so a note the server already embedded there is not shown
  /// a second time underneath it.
  final String answerText;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Widget> chips = <Widget>[];

    void add(String text, {Color? color}) {
      chips.add(Container(
        margin: const EdgeInsets.only(right: 6, top: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color ?? theme.dividerColor),
        ),
        child: GlobalBhashiniText(
          text,
          style: theme.textTheme.labelSmall?.copyWith(color: color),
        ),
      ));
    }

    if (meta.model != null && meta.model!.isNotEmpty) {
      add('model: ${meta.model}');
    }
    if (meta.mode != null) {
      add('mode: ${meta.mode}',
          color: meta.mode == 'offline' ? Colors.orange : Colors.green);
    }
    // The language the server detected in the question. Worth showing on its
    // own: it is what decides which advisory or glossary applies.
    if (meta.locale != null && meta.locale!.isNotEmpty) {
      add('locale: ${meta.locale}');
    }
    // Named `server tier` on purpose — it is the profile of the machine running
    // the API, not of the phone in the user's hand.
    if (meta.tier != null && meta.tier!.isNotEmpty && meta.tier != 'unknown') {
      add('server tier: ${meta.tier}');
    }
    if (meta.via != null && meta.via!.isNotEmpty) add('via ${meta.via}');
    if (meta.intent != null && meta.intent!.isNotEmpty) add('intent: ${meta.intent}');

    // The offline advisory is not always in the language that was asked in.
    // Saying which language was served beats letting `locale: ta` imply Tamil.
    if (meta.advisoryLocale != null && meta.advisoryLocale!.isNotEmpty) {
      final bool differs =
          meta.locale != null && meta.locale != meta.advisoryLocale;
      add(
        differs
            ? 'advisory in ${meta.advisoryLocale} (asked in ${meta.locale})'
            : 'advisory: ${meta.advisoryLocale}',
        color: differs ? Colors.orange : null,
      );
    }

    if (meta.retrievedCount != null || meta.selectedCount != null) {
      add('kept ${meta.selectedCount ?? 0}/${meta.retrievedCount ?? 0}');
    }
    if (meta.droppedBelowFloor != null && meta.droppedBelowFloor! > 0) {
      add('dropped below floor: ${meta.droppedBelowFloor}', color: Colors.orange);
    }
    if (meta.bestScore != null) {
      add('best score ${meta.bestScore!.toStringAsFixed(3)}');
    }
    if (meta.hasFloor) {
      add(
        meta.minScoreApplied == null
            ? 'no floor (safety exemption)'
            : 'floor ${meta.minScoreApplied}',
      );
    }
    if (meta.safetyStatic) {
      // Explains an `answer_model: none` that is not a refusal: the safety
      // module is policy-forbidden from reaching any language model.
      add('static safety content, no model', color: Colors.green);
    }
    if (meta.thin == true) {
      add('thin grounding', color: Colors.orange);
    }
    if (meta.generationLatencyMs != null) {
      add('gen ${meta.generationLatencyMs} ms');
    } else if (meta.totalLatencyMs != null) {
      add('${meta.totalLatencyMs} ms');
    }

    if (meta.isVoiceTurn) {
      add(
        meta.isAsr == false
            ? 'transcript: device text (not ASR)'
            : 'transcript: server ASR',
        color: meta.isAsr == false ? Colors.orange : null,
      );
    }

    if (chips.isEmpty && meta.deliveryNotice == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (meta.deliveryNotice != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: GlobalBhashiniText(
              meta.deliveryNotice!,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.orange),
            ),
          ),
        if (meta.thin == true &&
            meta.thinNote != null &&
            !answerText.contains(meta.thinNote!))
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: GlobalBhashiniText(
              meta.thinNote!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        if (chips.isNotEmpty) Wrap(children: chips),
      ],
    );
  }
}
