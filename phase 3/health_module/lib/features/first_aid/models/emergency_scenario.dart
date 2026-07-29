class EmergencyScenario {
  final int id;
  final String slug;
  final String title;
  final String category;
  final String urgencyLevel;
  final String? audioKey;

  final List<String> dangerSigns;
  final List<Map<String, String>> avoidActions; // {action, reason}
  final List<Map<String, String>> referralRules; // {rule, level}

  EmergencyScenario({
    required this.id,
    required this.slug,
    required this.title,
    required this.category,
    required this.urgencyLevel,
    this.audioKey,
    this.dangerSigns = const [],
    this.avoidActions = const [],
    this.referralRules = const [],
  });

  factory EmergencyScenario.fromMap(
    Map<String, dynamic> map, {
    List<String> dangerSigns = const [],
    List<Map<String, String>> avoidActions = const [],
    List<Map<String, String>> referralRules = const [],
  }) {
    return EmergencyScenario(
      id: map['id'],
      slug: map['slug'],
      title: map['title'],
      category: map['category'],
      urgencyLevel: map['urgency_level'],
      audioKey: map['audio_key'],
      dangerSigns: dangerSigns,
      avoidActions: avoidActions,
      referralRules: referralRules,
    );
  }
}
