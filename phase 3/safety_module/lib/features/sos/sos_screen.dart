import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:background_sms/background_sms.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/theme/safety_theme.dart';
import '../broadcasts/broadcast_screen.dart';
import '../../core/services/background_safety_service.dart';

class TrustedContact {
  final String name;
  final String relation;
  final String phone;
  const TrustedContact(this.name, this.relation, this.phone);

  String toStorageString() => '$name|$relation|$phone';

  static TrustedContact fromStorageString(String str) {
    final parts = str.split('|');
    if (parts.length >= 3) {
      return TrustedContact(parts[0], parts[1], parts[2]);
    }
    return TrustedContact(str, 'Trusted Contact', str);
  }
}

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> with SingleTickerProviderStateMixin {
  bool _sosActive = false;
  bool _shakeDetectionEnabled = true;
  String _locationStatus = 'Detecting high-accuracy GPS...';
  Position? _currentPosition;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  List<TrustedContact> _contacts = [];
  StreamSubscription<dynamic>? _accelerometerSub;
  int _shakeCount = 0;
  DateTime? _lastShakeTime;

  bool _liveTrackingEnabled = false;
  Timer? _liveTrackingTimer;

  int _sosTapCount = 0;
  Timer? _sosTapTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermissions();
    });
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _fetchLocation();
    _loadContacts();
    _initShakeDetection();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.sms,
      Permission.phone,
      Permission.location,
    ].request();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _accelerometerSub?.cancel();
    _liveTrackingTimer?.cancel();
    _sosTapTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final storedList = prefs.getStringList('sheguard_trusted_contacts');
    if (storedList != null && storedList.isNotEmpty) {
      setState(() {
        _contacts = storedList.map((s) => TrustedContact.fromStorageString(s)).toList();
      });
    } else {
      // Start with empty real contacts
      setState(() {
        _contacts = [];
      });
    }
  }

  Future<void> _saveContacts([List<TrustedContact>? toSave]) async {
    final prefs = await SharedPreferences.getInstance();
    final list = (toSave ?? _contacts).map((c) => c.toStorageString()).toList();
    await prefs.setStringList('sheguard_trusted_contacts', list);
  }

  void _initShakeDetection() {
    _accelerometerSub = userAccelerometerEventStream().listen((event) {
      if (!_shakeDetectionEnabled || _sosActive) return;

      final double acceleration = math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (acceleration > 15.0) { // High g-force threshold for vigorous shake
        final now = DateTime.now();
        if (_lastShakeTime == null || now.difference(_lastShakeTime!) > const Duration(seconds: 3)) {
          _shakeCount = 1;
        } else if (now.difference(_lastShakeTime!) > const Duration(milliseconds: 300)) {
          _shakeCount++;
        }
        _lastShakeTime = now;

        if (_shakeCount >= 3) {
          _shakeCount = 0;
          _triggerSos(fromShake: true);
        }
      }
    });
  }

  Future<void> _fetchLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => _locationStatus = 'GPS Disabled. Please turn on location services.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) setState(() => _locationStatus = 'Location permission denied.');
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _locationStatus = '📍 Live GPS: ${position.latitude.toStringAsFixed(4)}°, ${position.longitude.toStringAsFixed(4)}° (Accuracy: ${position.accuracy.toStringAsFixed(1)}m)';
        });
      }
    } catch (e) {
      if (mounted) setState(() => _locationStatus = 'Could not acquire GPS: $e');
    }
  }

  void _toggleLiveTracking(bool enable) async {
    setState(() => _liveTrackingEnabled = enable);
    final service = FlutterBackgroundService();
    
    if (enable) {
      bool isRunning = await service.isRunning();
      if (!isRunning) {
        await service.startService();
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Live Tracking active. Location updating in background.'),
        backgroundColor: Colors.green,
      ));
    } else {
      service.invoke("stopService");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Live Tracking disabled.'),
        backgroundColor: Colors.grey,
      ));
    }
  }

  void _handleSosTap() {
    _sosTapCount++;
    if (_sosTapTimer != null && _sosTapTimer!.isActive) {
      _sosTapTimer!.cancel();
    }
    
    if (_sosTapCount >= 3) {
      _sosTapCount = 0;
      _triggerSos(fromShake: false, isAuto: true);
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tap \${3 - _sosTapCount} more times rapidly to trigger Auto SOS.'),
          duration: const Duration(seconds: 1),
        ),
      );
      _sosTapTimer = Timer(const Duration(milliseconds: 1500), () {
        _sosTapCount = 0;
      });
    }
  }

  void _triggerSos({bool fromShake = false, bool isAuto = false}) async {
    if (_contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ No trusted emergency contacts saved! Please add a contact first.'),
          backgroundColor: SafetyTheme.primaryRed,
        ),
      );
      return;
    }

    setState(() {
      _sosActive = true;
    });

    String coords = _currentPosition != null ? 'https://maps.google.com/?q=${_currentPosition!.latitude},${_currentPosition!.longitude}' : 'Location unavailable';
    String messageBody = "EMERGENCY (Adyuta Safety): I need immediate help. My last known location is: $coords";

    if (isAuto || fromShake) {
      // 1. Auto Live Tracking Enable
      if (!_liveTrackingEnabled) {
        _toggleLiveTracking(true);
      }

      // 2. Auto SMS via BackgroundSms
      int smsSentCount = 0;
      for (var contact in _contacts) {
        try {
          var result = await BackgroundSms.sendMessage(phoneNumber: contact.phone, message: messageBody);
          if (result == SmsStatus.sent) smsSentCount++;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SMS Failed: \$e")));
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SOS Activated! SMS sent to \$smsSentCount contacts.')),
      );

      // 3. Auto Call first emergency contact
      if (_contacts.isNotEmpty) {
        try {
          await FlutterPhoneDirectCaller.callNumber(_contacts.first.phone);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Auto-Call Failed: \$e")));
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('SOS Activated! Auto-Calling and Sending SMS.'), backgroundColor: SafetyTheme.primaryRed),
      );
    } else {
      // Launch SMS intent for manual single tap
      String smsUrl = "sms:${_contacts.map((c) => c.phone).join(',')}?body=${Uri.encodeComponent(messageBody)}";

      launchUrl(Uri.parse(smsUrl)).catchError((e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open SMS app')),
          );
        }
        return false;
      });
    }

    _pulseController.duration = const Duration(milliseconds: 400);
    _pulseController.repeat(reverse: true);
    _showSosAlertModal(fromShake: fromShake);
  }

  void _toggleSosButton() {
    if (_sosActive) {
      setState(() {
        _sosActive = false;
        _pulseController.duration = const Duration(milliseconds: 1000);
        _pulseController.repeat(reverse: true);
      });
    } else {
      _triggerSos(fromShake: false);
    }
  }

  void _showSosAlertModal({required bool fromShake}) {
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
                child: const Icon(Icons.warning_amber_rounded, color: SafetyTheme.primaryRed, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                fromShake ? 'SHAKE-TO-SOS ACTIVATED!' : 'EMERGENCY SOS ACTIVATED!',
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: SafetyTheme.primaryRed),
              ),
              const SizedBox(height: 8),
              Text(
                'Siren alarm triggered! Dedicated SOS alert will broadcast strictly to your ${_contacts.length} saved trusted emergency contacts.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 13, color: SafetyTheme.textGrey, height: 1.4),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: SafetyTheme.primaryRed, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_locationStatus, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: SafetyTheme.textDark))),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _sendSmsToAllTrustedContacts();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: SafetyTheme.warningOrange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      icon: const Icon(Icons.sms, size: 18),
                      label: Text('SMS All (${_contacts.length})', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _makeEmergencyCall(_contacts.first.phone);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: SafetyTheme.primaryRed, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      icon: const Icon(Icons.call, size: 18),
                      label: Text('Call ${_contacts.first.name.split(' ')[0]}', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _sosActive = false;
                    _pulseController.duration = const Duration(milliseconds: 1000);
                    _pulseController.repeat(reverse: true);
                  });
                },
                child: Text('DEACTIVATE ALARM', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: SafetyTheme.textGrey)),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _makeEmergencyCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        await launchUrl(uri);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open phone dialer for $cleanPhone: $e')));
    }
  }

  Future<void> _sendSmsToContact(TrustedContact contact) async {
    final String locText = _currentPosition != null ? 'https://maps.google.com/?q=${_currentPosition!.latitude},${_currentPosition!.longitude}' : 'Location unavailable';
    final String body = Uri.encodeComponent('EMERGENCY SOS! I am in danger and need immediate help! My GPS location is: $locText');
    final cleanPhone = contact.phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('sms:$cleanPhone?body=$body');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        await launchUrl(uri);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open SMS app for ${contact.name}: $e')));
    }
  }

  Future<void> _sendSmsToAllTrustedContacts() async {
    if (_contacts.isEmpty) return;
    final String locText = _currentPosition != null ? 'https://maps.google.com/?q=${_currentPosition!.latitude},${_currentPosition!.longitude}' : 'Location unavailable';
    final String body = Uri.encodeComponent('EMERGENCY SOS! I am in danger and need immediate help! My GPS location is: $locText');
    
    // On Android, comma separation is standard for multiple SMS recipients
    final allPhones = _contacts.map((c) => c.phone.replaceAll(RegExp(r'[^0-9+]'), '')).join(',');
    final uri = Uri.parse('sms:$allPhones?body=$body');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        await _sendSmsToContact(_contacts.first);
      }
    } catch (e) {
      await _sendSmsToContact(_contacts.first);
    }
  }

  void _addContactDialog() {
    final nameCtrl = TextEditingController();
    final relCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Trusted Contact', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Contact Name', hintText: 'e.g., Sister / Friend')),
            TextField(controller: relCtrl, decoration: const InputDecoration(labelText: 'Relationship', hintText: 'e.g., Family')),
            TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone Number', hintText: '+91 98765 43210')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty && phoneCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _contacts.add(TrustedContact(nameCtrl.text.trim(), relCtrl.text.trim().isEmpty ? 'Trusted' : relCtrl.text.trim(), phoneCtrl.text.trim()));
                });
                _saveContacts();
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added "${nameCtrl.text.trim()}" to trusted contacts.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: SafetyTheme.primaryRed, foregroundColor: Colors.white),
            child: const Text('Add Contact'),
          ),
        ],
      ),
    );
  }

  void _editContactDialog(int index, TrustedContact old) {
    final nameCtrl = TextEditingController(text: old.name);
    final relCtrl = TextEditingController(text: old.relation);
    final phoneCtrl = TextEditingController(text: old.phone);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Modify Trusted Contact', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Contact Name')),
            TextField(controller: relCtrl, decoration: const InputDecoration(labelText: 'Relationship')),
            TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone Number')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty && phoneCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _contacts[index] = TrustedContact(nameCtrl.text.trim(), relCtrl.text.trim().isEmpty ? 'Trusted' : relCtrl.text.trim(), phoneCtrl.text.trim());
                });
                _saveContacts();
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Updated "${nameCtrl.text.trim()}" in trusted contacts.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _deleteContact(int index) {
    final removed = _contacts[index];
    setState(() {
      _contacts.removeAt(index);
    });
    _saveContacts();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed "${removed.name}" from trusted contacts.'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.amber,
          onPressed: () {
            setState(() {
              _contacts.insert(index, removed);
            });
            _saveContacts();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            elevation: 0,
            title: Row(
              children: [
                const Icon(Icons.shield, color: SafetyTheme.primaryRed),
                const SizedBox(width: 8),
                Text('Adyuta Shield', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: SafetyTheme.textDark)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.my_location, color: SafetyTheme.primaryRed),
                tooltip: 'Refresh GPS',
                onPressed: _fetchLocation,
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Location Shield Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: SafetyTheme.cardShadow,
                      border: Border.all(color: _sosActive ? SafetyTheme.primaryRed : const Color(0xFFE2E8F0), width: _sosActive ? 2 : 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _sosActive ? const Color(0xFFFEF2F2) : const Color(0xFFEFF6FF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_sosActive ? Icons.warning : Icons.gps_fixed, color: _sosActive ? SafetyTheme.primaryRed : const Color(0xFF3B82F6), size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _sosActive ? 'EMERGENCY BROADCAST ACTIVE' : 'Safety Shield Active',
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: _sosActive ? SafetyTheme.primaryRed : SafetyTheme.textDark),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _locationStatus,
                                style: GoogleFonts.inter(fontSize: 11, color: SafetyTheme.textGrey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Big Pulsing Emergency SOS Button
                  GestureDetector(
                    onTap: _handleSosTap,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 210,
                            height: 210,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: _sosActive
                                  ? const LinearGradient(colors: [Color(0xFFB91C1C), Color(0xFF7F1D1D)])
                                  : SafetyTheme.sosGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: SafetyTheme.primaryRed.withOpacity(_sosActive ? 0.6 : 0.35),
                                  blurRadius: _sosActive ? 40 : 25,
                                  spreadRadius: _sosActive ? 8 : 2,
                                ),
                              ],
                              border: Border.all(color: Colors.white, width: 6),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(_sosActive ? Icons.notifications_active : Icons.touch_app, size: 56, color: Colors.white),
                                const SizedBox(height: 8),
                                Text(
                                  _sosActive ? 'STOP SOS' : 'TAP FOR SOS',
                                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.2),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _sosActive ? 'Alerting ${_contacts.length} Contacts' : 'Instant Emergency Alert',
                                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Shake Detection Toggle Bar (Ported from SheGuard)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: SafetyTheme.cardShadow,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: const Color(0xFFF3E8FF), borderRadius: BorderRadius.circular(12)),
                                child: const Icon(Icons.vibration, color: Color(0xFF9333EA), size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Shake Detection to SOS', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: SafetyTheme.textDark)),
                                    Text('Shake phone 3 times to trigger siren & alerts', style: GoogleFonts.inter(fontSize: 11, color: SafetyTheme.textGrey)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _shakeDetectionEnabled,
                          activeColor: const Color(0xFF9333EA),
                          onChanged: (val) => setState(() => _shakeDetectionEnabled = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Trusted Contacts Section
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.people_alt, color: SafetyTheme.textDark, size: 20),
                            const SizedBox(width: 8),
                            Text('Trusted Emergency Contacts (${_contacts.length})', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: SafetyTheme.textDark)),
                          ],
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: _addContactDialog,
                          icon: const Icon(Icons.add_circle, color: SafetyTheme.primaryRed, size: 18),
                          label: Text('Add', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: SafetyTheme.primaryRed)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (_contacts.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.person_off, color: SafetyTheme.primaryRed, size: 36),
                          const SizedBox(height: 8),
                          Text('No Trusted Contacts Saved', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: const Color(0xFF7F1D1D))),
                          const SizedBox(height: 4),
                          Text('Tap "Add" above to save emergency contacts who will receive your SOS alerts when triggered.', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12, color: SafetyTheme.textGrey)),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _contacts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final c = _contacts[index];
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: SafetyTheme.cardShadow,
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: SafetyTheme.primaryRed.withOpacity(0.12),
                                child: Text(c.name.isNotEmpty ? c.name[0].toUpperCase() : '?', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: SafetyTheme.primaryRed)),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: SafetyTheme.textDark)),
                                    Text('${c.relation} • ${c.phone}', style: GoogleFonts.inter(fontSize: 12, color: SafetyTheme.textGrey)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.call, color: Color(0xFF16A34A), size: 18),
                                tooltip: 'Call Contact',
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                onPressed: () => _makeEmergencyCall(c.phone),
                              ),
                              IconButton(
                                icon: const Icon(Icons.sms, color: Color(0xFF2563EB), size: 18),
                                tooltip: 'Send SMS',
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                onPressed: () => _sendSmsToContact(c),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF64748B), size: 18),
                                tooltip: 'Modify Contact',
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                onPressed: () => _editContactDialog(index, c),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: SafetyTheme.primaryRed, size: 18),
                                tooltip: 'Remove Contact',
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                onPressed: () => _deleteContact(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
