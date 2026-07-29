class FirstAidStep {
  final int id;
  final int topicId;
  final int stepNo;
  final String type;
  final String textContent;

  FirstAidStep({
    required this.id,
    required this.topicId,
    required this.stepNo,
    required this.type,
    required this.textContent,
  });

  factory FirstAidStep.fromMap(Map<String, dynamic> map) {
    return FirstAidStep(
      id: map['id'],
      topicId: map['topic_id'],
      stepNo: map['step_no'],
      type: map['type'],
      textContent: map['text_content'],
    );
  }
}
