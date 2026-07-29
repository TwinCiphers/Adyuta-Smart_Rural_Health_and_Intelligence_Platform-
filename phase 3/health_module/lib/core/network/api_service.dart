import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../features/directory/models/facility.dart';
import '../../features/pharmacy/models/medicine.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // ─── Live Hospital/Facility Data ─────────────────────────────────────────
  // Uses OpenStreetMap Overpass API — free, no key needed.
  // Falls back gracefully; seeded local data always available even if this fails.
  Future<List<Facility>> fetchFacilities() async {
    try {
      final uri = Uri.parse(
        'https://overpass-api.de/api/interpreter'
        '?data=[out:json][timeout:10];'
        'node(around:25000,12.9716,77.5946)[amenity~"hospital|clinic|pharmacy"];out 50;'
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final elements = data['elements'] as List? ?? [];
        List<Facility> facilities = [];
        int idStart = 1000;
        for (final node in elements) {
          final tags = node['tags'] as Map? ?? {};
          final name = (tags['name'] ?? '').toString().trim();
          if (name.isEmpty) continue;
          facilities.add(Facility(
            id: idStart++,
            name: name,
            type: tags['amenity'] == 'hospital' ? 'Hospital' : tags['amenity'] == 'pharmacy' ? 'Pharmacy' : 'Clinic',
            system: 'Allopathic',
            address: [
              tags['addr:housenumber'],
              tags['addr:street'],
              tags['addr:city'],
            ].where((s) => s != null).join(', ').isNotEmpty
                ? [tags['addr:housenumber'], tags['addr:street'], tags['addr:city']].where((s) => s != null).join(', ')
                : 'Lat: ${node['lat']}, Lon: ${node['lon']}',
            phone: tags['phone'] ?? tags['contact:phone'],
            workingHours: tags['opening_hours'] ?? 'Contact facility for hours',
            is24x7: tags['emergency'] == 'yes' ? 1 : 0,
          ));
        }
        if (facilities.isNotEmpty) {
          debugPrint('ApiService: Fetched ${facilities.length} facilities from Overpass API.');
          return facilities;
        }
      } else {
        debugPrint('ApiService: Overpass returned ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ApiService: fetchFacilities failed — using local data. Error: $e');
    }
    // Return empty — sync service will keep the seeded local data untouched.
    return [];
  }

  // ─── Live Medicine Data ───────────────────────────────────────────────────
  // Uses NLM RxNav API — free, no key, very reliable, returns real drug names.
  Future<List<Medicine>> fetchMedicines() async {
    try {
      // Fetch real drug names from NLM RxNorm (WHO INN list)
      final uri = Uri.parse(
        'https://rxnav.nlm.nih.gov/REST/drugs.json?name=&rxcui=&source=&rela='
      );
      // Try OpenFDA for real data
      final fdaUri = Uri.parse(
        'https://api.fda.gov/drug/label.json'
        '?search=openfda.product_type:%22HUMAN+PRESCRIPTION+DRUG%22'
        '&limit=25'
      );
      final response = await http.get(fdaUri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List? ?? [];
        List<Medicine> medicines = [];
        int idStart = 2000;
        for (final item in results) {
          final openfda = item['openfda'] as Map? ?? {};
          final brandList = openfda['brand_name'] as List?;
          final genericList = openfda['generic_name'] as List?;
          final usesList = item['indications_and_usage'] as List?;
          final dosageList = item['dosage_and_administration'] as List?;

          final brand = brandList?.first?.toString() ?? '';
          final generic = genericList?.first?.toString() ?? '';
          if (brand.isEmpty && generic.isEmpty) continue;

          String uses = (usesList?.first ?? 'See prescribing information.').toString();
          if (uses.length > 200) uses = '${uses.substring(0, 197)}...';

          String dosage = (dosageList?.first ?? 'As directed by physician.').toString();
          if (dosage.length > 150) dosage = '${dosage.substring(0, 147)}...';

          medicines.add(Medicine(
            id: idStart++,
            system: 'Allopathic',
            brandName: brand.length > 80 ? brand.substring(0, 80) : brand,
            genericName: generic.length > 80 ? generic.substring(0, 80) : generic,
            uses: uses,
            dosageAndForm: dosage,
            sourceRef: 'OpenFDA / NLM',
          ));
        }
        if (medicines.isNotEmpty) {
          debugPrint('ApiService: Fetched ${medicines.length} medicines from OpenFDA.');
          return medicines;
        }
      } else {
        debugPrint('ApiService: OpenFDA returned ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ApiService: fetchMedicines failed — using local data. Error: $e');
    }
    // Return empty — sync service will keep seeded local data.
    return [];
  }
}
