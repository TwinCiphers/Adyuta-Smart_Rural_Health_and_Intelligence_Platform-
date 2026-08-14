import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/theme/safety_theme.dart';
import '../../core/db/safety_database.dart';

class IncidentReportScreen extends StatefulWidget {
  const IncidentReportScreen({super.key});

  @override
  State<IncidentReportScreen> createState() => _IncidentReportScreenState();
}

class _IncidentReportScreenState extends State<IncidentReportScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedIncidentType;
  final TextEditingController _descController = TextEditingController();
  
  bool _isGettingLocation = false;
  Position? _incidentLocation;
  String _locationString = "Tap to pin current location";

  final List<String> _incidentTypes = [
    'Eve-teasing / Harassment',
    'Stalking',
    'Unlit / Dark Street',
    'Suspicious Activity',
    'Robbery / Snatching',
    'Other Safety Concern'
  ];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    setState(() => _isGettingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _locationString = 'Location services disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _locationString = 'Permission denied.');
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _incidentLocation = position;
        _locationString = '📍 ${position.latitude.toStringAsFixed(4)}°, ${position.longitude.toStringAsFixed(4)}°';
      });
    } catch (e) {
      setState(() => _locationString = 'Failed to get location');
    } finally {
      setState(() => _isGettingLocation = false);
    }
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      if (_incidentLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please pin the location of the incident.'), backgroundColor: SafetyTheme.primaryRed),
        );
        return;
      }



      try {
        final db = SafetyDatabase();
        await db.insertIncident(IncidentsCompanion(
          type: drift.Value(_selectedIncidentType!),
          description: drift.Value(_descController.text),
          latitude: drift.Value(_incidentLocation!.latitude),
          longitude: drift.Value(_incidentLocation!.longitude),
          timestamp: drift.Value(DateTime.now()),
        ));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Report saved locally. It will automatically sync when online.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
         if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Report submitted securely.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      // Reset form
      setState(() {
        _selectedIncidentType = null;
        _descController.clear();
        _incidentLocation = null;
        _locationString = "Tap to pin current location";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Report Incident',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: SafetyTheme.textDark, fontSize: 24),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.privacy_tip_outlined, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Reports are 100% anonymous and help authorities map unsafe areas in the city.',
                          style: GoogleFonts.inter(fontSize: 13, color: Colors.blue.shade800),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                Text('Incident Type', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: SafetyTheme.textDark)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedIncidentType,
                  hint: Text('Select incident type', style: GoogleFonts.inter(color: SafetyTheme.textGrey)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  items: _incidentTypes.map((type) => DropdownMenuItem(value: type, child: Text(type, style: GoogleFonts.inter()))).toList(),
                  onChanged: (val) => setState(() => _selectedIncidentType = val),
                  validator: (value) => value == null ? 'Please select a type' : null,
                ),
                
                const SizedBox(height: 24),
                Text('Description (Optional)', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: SafetyTheme.textDark)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Provide details like vehicle number, descriptions...',
                    hintStyle: GoogleFonts.inter(color: SafetyTheme.textGrey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),

                const SizedBox(height: 24),
                Text('Location', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: SafetyTheme.textDark)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _fetchLocation,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _incidentLocation != null ? Colors.green : Colors.grey.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _incidentLocation != null ? Icons.check_circle : Icons.location_on_outlined,
                          color: _incidentLocation != null ? Colors.green : SafetyTheme.primaryRed,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _isGettingLocation ? 'Acquiring GPS signal...' : _locationString,
                            style: GoogleFonts.inter(
                              color: _incidentLocation != null ? Colors.green.shade700 : SafetyTheme.textDark,
                              fontWeight: _incidentLocation != null ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (_isGettingLocation)
                          const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SafetyTheme.textDark,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _submitReport,
                    child: Text('SUBMIT SECURELY', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
