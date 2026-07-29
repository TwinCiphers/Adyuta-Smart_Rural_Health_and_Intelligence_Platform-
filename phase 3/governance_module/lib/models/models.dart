class GovernmentScheme {
  final String id;
  final String title;
  final String ministry;
  final String beneficiaries;
  final String category;
  final List<String> eligibilityCriteria;
  final List<String> requiredDocuments;
  final String benefits;
  final String officialWebsite;
  bool isBookmarked;

  GovernmentScheme({
    required this.id,
    required this.title,
    required this.ministry,
    required this.beneficiaries,
    required this.category,
    required this.eligibilityCriteria,
    required this.requiredDocuments,
    required this.benefits,
    required this.officialWebsite,
    this.isBookmarked = false,
  });
}

class StatutoryLaw {
  final String id;
  final String title;
  final String domain; // e.g. Constitution, RBI & Finance, Police & FIR, Cyberlaws, Farmer Rights, Labor/MGNREGA
  final String actCitation;
  final String sectionNumber;
  final String plainExplanation;
  final List<String> citizenRights;
  final String officialUrl;

  StatutoryLaw({
    required this.id,
    required this.title,
    required this.domain,
    required this.actCitation,
    required this.sectionNumber,
    required this.plainExplanation,
    required this.citizenRights,
    required this.officialUrl,
  });
}

class CitizenDocument {
  final String id;
  final String docName;
  final String issuer;
  bool isReady;
  final String description;

  CitizenDocument({
    required this.id,
    required this.docName,
    required this.issuer,
    this.isReady = false,
    required this.description,
  });
}
