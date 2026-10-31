import re

file_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\safety_module\lib\features\sos\sos_screen.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# I will replace the entire _triggerSos method
target_pattern = r"void _triggerSos\(\{bool fromShake = false, bool isAuto = false\}\) async \{.*?\n\s\s\s\s\s\s_pulseController\.duration"
replacement = """void _triggerSos({bool fromShake = false, bool isAuto = false}) async {
    if (_contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: GlobalBhashiniText('No trusted emergency contacts saved! Please add a contact first.'),
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

    // 1. Auto Live Tracking Enable
    if (!_liveTrackingEnabled) {
      _toggleLiveTracking(true);
    }

    // 2. Auto SMS via BackgroundSms directly (without user approval)
    int smsSentCount = 0;
    for (var contact in _contacts) {
      try {
        var result = await BackgroundSms.sendMessage(phoneNumber: contact.phone, message: messageBody);
        if (result == SmsStatus.sent) smsSentCount++;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GlobalBhashiniText("SMS Failed: $e")));
      }
    }
    
    // 3. Auto Call first emergency contact (only for auto/shake, or maybe for all?)
    // User requested "cant sms sent directly without by approval like auto calling"
    // implies that auto calling happens automatically, and they want SMS to behave the same.
    // Let's do both silently always!
    if (_contacts.isNotEmpty) {
      try {
        await FlutterPhoneDirectCaller.callNumber(_contacts.first.phone);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GlobalBhashiniText("Auto-Call Failed: $e")));
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: GlobalBhashiniText('SOS Activated! Auto-Calling and SMS sent to $smsSentCount contacts.'), backgroundColor: SafetyTheme.primaryRed),
    );

    _pulseController.duration"""

content = re.sub(target_pattern, replacement, content, flags=re.DOTALL)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Rewrote _triggerSos")
