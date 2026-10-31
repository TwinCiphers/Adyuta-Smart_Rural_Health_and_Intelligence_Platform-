/// The result of one request, kept as four distinct cases.
///
/// The backend deliberately separates these and the UI must not collapse them.
/// Collapsing them is exactly how the literal string
/// `[PLACEHOLDER - no LLM connected in Stage 5E-A]` ends up rendered to a
/// villager as though it were a real medical answer.
sealed class ChatOutcome {
  const ChatOutcome();

  /// Text safe to render in the answer area, or null when there is nothing
  /// genuine to show and the caller should render [notice] instead.
  String? get displayText => null;

  /// Short explanation shown when [displayText] is null.
  String get notice => '';

  /// Whether this reply came from a real generator/retriever at all.
  bool get isGenuine => false;
}

/// The server returned a real, grounded answer.
///
/// This also covers the router's offline path: a local-lite template is real
/// deterministic content, not a placeholder, and the reply's `via` field says
/// `local:<intent>` so the UI can label it as offline.
final class Answered extends ChatOutcome {
  const Answered(this.text);

  final String text;

  @override
  String? get displayText => text;

  @override
  bool get isGenuine => true;
}

/// The server declined to answer and said so in the `answer` field itself:
/// nothing it retrieved cleared the relevance floor, so no model was ever
/// called (`answer_model` is `none`, `selected_count` is 0).
///
/// This is distinct from [Abstained], which is the `empty_retrieval` status,
/// and from [Answered], because the text is a refusal rather than guidance. It
/// is shown as written — the server's own wording is the honest part — but it
/// is labelled so nobody reads it as an answer.
final class Declined extends ChatOutcome {
  const Declined(this.text);

  final String text;

  @override
  String? get displayText => text;

  @override
  String get notice =>
      'No passage cleared the relevance floor, so no model was called. The '
      'server explained that in place of an answer.';
}

/// Retrieval found nothing above the relevance floor, so the server abstained
/// on purpose (`status == "empty_retrieval"`).
final class Abstained extends ChatOutcome {
  const Abstained();

  @override
  String get notice =>
      'The knowledge base had nothing relevant for this question, so the '
      'server refused to answer rather than guess. Try rephrasing it, or ask '
      'about crops, symptoms, schemes, lessons or safety.';
}

/// The server has no generator wired up (`dummy` adapter, or a missing or
/// expired API key). The response still carries an `answer` string, but it is a
/// placeholder, not guidance.
final class Placeholder extends ChatOutcome {
  const Placeholder(this.model);

  final String model;

  @override
  String get notice =>
      'The server has no language model connected right now (adapter: '
      '${model.isEmpty ? 'unknown' : model}), so no generated answer exists. '
      'The knowledge base was searched and the sources below are real, but '
      'nothing here is advice.';
}

/// The request never produced a usable result.
final class Failed extends ChatOutcome {
  const Failed({required this.message, this.statusCode, this.networkError = false});

  final String message;
  final int? statusCode;
  final bool networkError;

  @override
  String get notice => message;
}

/// A transcript that is deliberately NOT presented as server-side speech
/// recognition (the offline `device_supplied` path).
final class DeviceTranscript extends ChatOutcome {
  const DeviceTranscript(this.text);

  final String text;

  @override
  String? get displayText => text;

  @override
  bool get isGenuine => true;
}
