import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../data/gov_data.dart';

class GovStorageService {
  static const String _savedSchemeIdsKey = 'gov_saved_scheme_ids';
  static const String _readyDocIdsKey = 'gov_ready_doc_ids';

  static Future<List<String>> getSavedSchemeIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_savedSchemeIdsKey) ?? [];
  }

  static Future<List<String>> getReadyDocIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_readyDocIdsKey) ?? [];
  }

  static Future<List<GovernmentScheme>> loadSchemesWithStatus() async {
    final savedIds = await getSavedSchemeIds();
    for (var scheme in GovCatalog.schemes) {
      scheme.isBookmarked = savedIds.contains(scheme.id);
    }
    return GovCatalog.schemes;
  }

  static Future<List<CitizenDocument>> loadDocumentsWithStatus() async {
    final readyIds = await getReadyDocIds();
    for (var doc in GovCatalog.initialDocuments) {
      doc.isReady = readyIds.contains(doc.id);
    }
    return GovCatalog.initialDocuments;
  }

  static Future<void> toggleSchemeBookmark(String schemeId, bool isSaved) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_savedSchemeIdsKey) ?? [];
    if (isSaved) {
      if (!list.contains(schemeId)) list.add(schemeId);
    } else {
      list.remove(schemeId);
    }
    await prefs.setStringList(_savedSchemeIdsKey, list);
  }

  static Future<void> toggleDocumentReady(String docId, bool isReady) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_readyDocIdsKey) ?? [];
    if (isReady) {
      if (!list.contains(docId)) list.add(docId);
    } else {
      list.remove(docId);
    }
    await prefs.setStringList(_readyDocIdsKey, list);
  }

  static Future<int> getReadyDocumentCount() async {
    final readyIds = await getReadyDocIds();
    return readyIds.length;
  }
}
