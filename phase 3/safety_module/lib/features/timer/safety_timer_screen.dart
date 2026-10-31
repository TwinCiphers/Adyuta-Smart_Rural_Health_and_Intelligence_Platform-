import 'package:bhashini_core/bhashini_core.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../sos/sos_screen.dart'; // For TrustedContact
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../core/theme/safety_theme.dart';

class SafetyTimerScreen extends StatefulWidget {
  const SafetyTimerScreen({super.key});

  @override
  State<SafetyTimerScreen> createState() => _SafetyTimerScreenState();
}

class _SafetyTimerScreenState extends State<SafetyTimerScreen> with TickerProviderStateMixin {
  bool _isRunning = false;
  int _totalSeconds = 0;
  int _remainingSeconds = 0;
  Timer? _timer;

  final List<int> _quickDurations = [15 * 60, 30 * 60, 60 * 60]; // 15m, 30m, 1h
  int _selectedDurationIndex = 0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _totalSeconds = _quickDurations[_selectedDurationIndex];
    _remainingSeconds = _totalSeconds;

    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _remainingSeconds = _totalSeconds;
    });
    _pulseController.repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        _triggerTimerSOS();
      }
    });
  }

  void _cancelTimer() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: GlobalBhashiniText('Cancel Timer?', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: GlobalBhashiniText('Are you sure you have reached safely?', style: GoogleFonts.inter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: GlobalBhashiniText('NO', style: GoogleFonts.inter(color: SafetyTheme.textGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: SafetyTheme.primaryRed),
            onPressed: () {
              Navigator.pop(ctx);
              _stopTimerLogic();
            },
            child: GlobalBhashiniText('YES, CANCEL', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _stopTimerLogic() {
    _timer?.cancel();
    _pulseController.stop();
    _pulseController.reset();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _totalSeconds;
    });
  }

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
              GlobalBhashiniText(
                'SOS SENT!',
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: SafetyTheme.primaryRed),
              ),
              const SizedBox(height: 8),
              GlobalBhashiniText(
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
                  child: GlobalBhashiniText('DISMISS', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1.0 - (_remainingSeconds / _totalSeconds);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: GlobalBhashiniText(
          'Safety Timer',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: SafetyTheme.textDark, fontSize: 24),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 10),
              GlobalBhashiniText(
                'Set a timer while traveling. If you don\'t cancel it before time runs out, an SOS will be triggered automatically.',
                style: GoogleFonts.inter(color: SafetyTheme.textGrey, fontSize: 14, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isRunning ? _pulseAnimation.value : 1.0,
                    child: CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 15.0,
                      percent: progress.clamp(0.0, 1.0),
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      progressColor: _isRunning ? SafetyTheme.warningOrange : SafetyTheme.primaryRed,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GlobalBhashiniText(
                            _formatTime(_remainingSeconds),
                            style: GoogleFonts.inter(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: SafetyTheme.textDark,
                            ),
                          ),
                          GlobalBhashiniText(
                            _isRunning ? 'REMAINING' : 'MINUTES',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: SafetyTheme.textGrey,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),
              
              if (!_isRunning) ...[
                GlobalBhashiniText(
                  'Select Duration',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: SafetyTheme.textDark, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_quickDurations.length, (index) {
                    final isSelected = _selectedDurationIndex == index;
                    final mins = _quickDurations[index] ~/ 60;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDurationIndex = index;
                          _totalSeconds = _quickDurations[index];
                          _remainingSeconds = _totalSeconds;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? SafetyTheme.primaryRed : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? SafetyTheme.primaryRed : Colors.grey.withOpacity(0.3),
                          ),
                          boxShadow: isSelected ? SafetyTheme.glowShadow : [],
                        ),
                        child: GlobalBhashiniText(
                          '$mins m',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isSelected ? Colors.white : SafetyTheme.textDark,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SafetyTheme.textDark,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                    ),
                    onPressed: _startTimer,
                    child: GlobalBhashiniText(
                      'START "WATCH ME"',
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SafetyTheme.primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 8,
                      shadowColor: SafetyTheme.primaryRed.withOpacity(0.5),
                    ),
                    onPressed: _cancelTimer,
                    icon: const Icon(Icons.stop_circle_outlined, color: Colors.white, size: 28),
                    label: GlobalBhashiniText(
                      'I\'M SAFE - STOP TIMER',
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
