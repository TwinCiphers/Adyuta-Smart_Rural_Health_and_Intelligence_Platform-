class MaternalVaccine {
  final int id;
  final String code;
  final String title;
  final String recommendedTime;

  MaternalVaccine({
    required this.id,
    required this.code,
    required this.title,
    required this.recommendedTime,
  });

  factory MaternalVaccine.fromMap(Map<String, dynamic> map) {
    return MaternalVaccine(
      id: map['id'],
      code: map['code'],
      title: map['title'],
      recommendedTime: map['recommended_time'],
    );
  }
}

class DangerSign {
  final int id;
  final String stage;
  final String signText;
  final String referralLevel;

  DangerSign({
    required this.id,
    required this.stage,
    required this.signText,
    required this.referralLevel,
  });

  factory DangerSign.fromMap(Map<String, dynamic> map) {
    return DangerSign(
      id: map['id'],
      stage: map['stage'],
      signText: map['sign_text'],
      referralLevel: map['referral_level'],
    );
  }
}

class PregnancyWeek {
  final int weekNo;
  final String babyGrowth;
  final String motherChanges;
  final String dietTip;
  final String activityTip;
  final String warningSigns;

  PregnancyWeek({
    required this.weekNo,
    required this.babyGrowth,
    required this.motherChanges,
    required this.dietTip,
    required this.activityTip,
    required this.warningSigns,
  });

  factory PregnancyWeek.fromMap(Map<String, dynamic> map) {
    return PregnancyWeek(
      weekNo: map['week_no'],
      babyGrowth: map['baby_growth'],
      motherChanges: map['mother_changes'],
      dietTip: map['diet_tip'] ?? '',
      activityTip: map['activity_tip'] ?? '',
      warningSigns: map['warning_signs'] ?? '',
    );
  }
}
