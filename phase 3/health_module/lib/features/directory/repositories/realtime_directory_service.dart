import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/facility.dart';

class RealTimeDirectoryService {
  static Future<List<Facility>> searchHospitalsByCity(String cityQuery) async {
    try {
      // 1. Get Coordinates for City via Nominatim
      final geoUrl = Uri.parse('https://nominatim.openstreetmap.org/search?q=$cityQuery&format=json&limit=1');
      final geoRes = await http.get(geoUrl, headers: {'User-Agent': 'AdyutaHealthApp/1.0'});
      if (geoRes.statusCode != 200) return [];
      
      final List geoData = json.decode(geoRes.body);
      if (geoData.isEmpty) return [];
      
      final lat = geoData[0]['lat'];
      final lon = geoData[0]['lon'];

      // 2. Query Overpass API for Hospitals around 20km radius
      // [out:json];node["amenity"="hospital"](around:20000,lat,lon);out 30;
      final query = '[out:json];(node["amenity"~"hospital|clinic"](around:30000,$lat,$lon);way["amenity"~"hospital|clinic"](around:30000,$lat,$lon););out center 40;';
      final overpassUrl = Uri.parse('https://overpass-api.de/api/interpreter');
      
      final res = await http.post(overpassUrl, body: {'data': query});
      if (res.statusCode != 200) return [];
      
      final data = json.decode(res.body);
      final elements = data['elements'] as List;
      
      List<Facility> facilities = [];
      for (var el in elements) {
        final tags = el['tags'] ?? {};
        final name = tags['name'] ?? 'General Medical Facility';
        
        final isWay = el['type'] == 'way';
        final plat = isWay ? el['center']['lat'] : el['lat'];
        final plon = isWay ? el['center']['lon'] : el['lon'];

        String address = '${tags['addr:street'] ?? ''} ${tags['addr:city'] ?? ''}'.trim();
        if (address.isEmpty) address = 'Address on Maps';

                facilities.add(Facility(
          id: int.tryParse(el['id'].toString()) ?? 0,
          name: name,
          type: tags['amenity'] == 'clinic' ? 'Clinic' : 'Hospital',
          system: 'Allopathic',
          address: address,
          phone: tags['phone'] ?? '108',
          workingHours: tags['opening_hours'] ?? '24/7',
          is24x7: tags['emergency'] == 'yes' ? 1 : 0,
        ));
      }
      // If we don't find enough, we fall back to general city query
      return facilities;
    } catch (e) {
      return [];
    }
  }
}
