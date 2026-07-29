class PurchaseLink {
  final int id;
  final String platform;
  final String url;

  PurchaseLink({required this.id, required this.platform, required this.url});

  factory PurchaseLink.fromMap(Map<String, dynamic> map) {
    return PurchaseLink(
      id: map['id'],
      platform: map['platform'],
      url: map['url'],
    );
  }
}

class Medicine {
  final int id;
  final String system;
  final String? brandName;
  final String? genericName;
  final String? uses;
  final String? mechanism;
  final String? dosageAndForm;
  final String? sideEffects;
  final String? drugInteractions;
  final String? warningsAndContraindications;
  final String? safetyPregnancyLactation;
  final String? qualityStandardization;
  final String? manufacturerApproval;
  final String? sourceRef;

  // Ayurveda Meta
  final String? botanicalName;
  final String? family;
  final String? vernacularNames;
  final String? partUsed;

  // Purchase Links
  List<PurchaseLink> purchaseLinks;

  Medicine({
    required this.id,
    required this.system,
    this.brandName,
    this.genericName,
    this.uses,
    this.mechanism,
    this.dosageAndForm,
    this.sideEffects,
    this.drugInteractions,
    this.warningsAndContraindications,
    this.safetyPregnancyLactation,
    this.qualityStandardization,
    this.manufacturerApproval,
    this.sourceRef,
    this.botanicalName,
    this.family,
    this.vernacularNames,
    this.partUsed,
    this.purchaseLinks = const [],
  });

  factory Medicine.fromMap(Map<String, dynamic> map, {List<PurchaseLink> links = const []}) {
    return Medicine(
      id: map['id'],
      system: map['system'],
      brandName: map['brand_name'],
      genericName: map['generic_name'],
      uses: map['uses'],
      mechanism: map['mechanism'],
      dosageAndForm: map['dosage_and_form'],
      sideEffects: map['side_effects'],
      drugInteractions: map['drug_interactions'],
      warningsAndContraindications: map['warnings_and_contraindications'],
      safetyPregnancyLactation: map['safety_pregnancy_lactation'],
      qualityStandardization: map['quality_standardization'],
      manufacturerApproval: map['manufacturer_approval'],
      sourceRef: map['source_ref'],
      botanicalName: map['botanical_name'],
      family: map['family'],
      vernacularNames: map['vernacular_names'],
      partUsed: map['part_used'],
      purchaseLinks: links,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'system': system,
      'brand_name': brandName,
      'generic_name': genericName,
      'uses': uses,
      'dosage_and_form': dosageAndForm,
      'source_ref': sourceRef,
    };
  }
}
