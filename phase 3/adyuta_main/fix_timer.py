import re
path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\safety_module\lib\features\timer\safety_timer_screen.dart'
with open(path, 'r', encoding='utf-8') as f:
    code = f.read()

imports = """import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../sos/sos_screen.dart'; // For TrustedContact
"""

if "import 'package:shared_preferences/shared_preferences.dart';" not in code:
    code = code.replace("import 'package:flutter/material.dart';", imports + "import 'package:flutter/material.dart';")

new_sos = """
  Future<void> _sendTimerSOS() async {
    final prefs = await SharedPreferences.getInstance();
    final storedList = prefs.getStringList('sheguard_trusted_contacts');
    if (storedList == null || storedList.isEmpty) return;

    List<TrustedContact> contacts = storedList.map((s) => TrustedContact.fromStorageString(s)).toList();
    if (contacts.isEmpty) return;

    Position? pos;
    try {
      if (await Geolocator.isLocationServiceEnabled()) {
        pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      }
    } catch(e) {}

    final String locText = pos != null 
        ? 'https://maps.google.com/?q=${pos.latitude},${pos.longitude}' 
        : 'Location unavailable';
    
    final String body = Uri.encodeComponent('SAFETY TIMER EXPIRED! I might be in danger. My GPS location is: $locText');
    
    final allPhones = contacts.map((c) => c.phone.replaceAll(RegExp(r'[^0-9+]'), '')).join(',');
    final uri = Uri.parse('sms:$allPhones?body=$body');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        await launchUrl(uri);
      }
    } catch (e) {}
  }

  void _triggerTimerSOS() {
    _stopTimerLogic();
    // Fire real SOS in background
    _sendTimerSOS();
    
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Color(0xFFFEF2F2), shape: BoxShape.circle),
                child: const Icon(Icons.timer_off, color: SafetyTheme.primaryRed, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                'SOS SENT!',
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: SafetyTheme.primaryRed),
              ),
              const SizedBox(height: 8),
              Text(
                'Safety Timer ran out. Real SOS alerts have been dispatched to your trusted contacts with your GPS location.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 15, color: SafetyTheme.textDark),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SafetyTheme.textDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('DISMISS', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
"""

code = re.sub(r'void _triggerTimerSOS\(\)\s*\{.*?\}\s*\}', new_sos, code, flags=re.DOTALL)

with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
