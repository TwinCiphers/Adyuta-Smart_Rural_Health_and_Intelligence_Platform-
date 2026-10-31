import re

file_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\safety_module\lib\features\sos\sos_screen.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

target = r"""    if (isAuto || fromShake) {
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GlobalBhashiniText("SMS Failed: \$e")));
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: GlobalBhashiniText('SOS Activated! SMS sent to \$smsSentCount contacts.')),
      );

      // 3. Auto Call first emergency contact
      if (_contacts.isNotEmpty) {
        try {
          await FlutterPhoneDirectCaller.callNumber(_contacts.first.phone);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GlobalBhashiniText("Auto-Call Failed: \$e")));
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: GlobalBhashiniText('SOS Activated! Auto-Calling and Sending SMS.'), backgroundColor: SafetyTheme.primaryRed),
      );
    } else {
      // Launch SMS intent for manual single tap
      String smsUrl = "sms:${_contacts.map((c) => c.phone).join(',')}?body=${Uri.encodeComponent(messageBody)}";

      launchUrl(Uri.parse(smsUrl)).catchError((e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: GlobalBhashiniText('Could not open SMS app')),
          );
        }
        return false;
      });
    }"""

replacement = """    // 1. Auto Live Tracking Enable
    if (!_liveTrackingEnabled) {
      _toggleLiveTracking(true);
    }

    // 2. Auto SMS via BackgroundSms silently
    int smsSentCount = 0;
    for (var contact in _contacts) {
      try {
        var result = await BackgroundSms.sendMessage(phoneNumber: contact.phone, message: messageBody);
        if (result == SmsStatus.sent) smsSentCount++;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GlobalBhashiniText("SMS Failed: $e")));
      }
    }

    // 3. Auto Call first emergency contact
    if (_contacts.isNotEmpty) {
      try {
        await FlutterPhoneDirectCaller.callNumber(_contacts.first.phone);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GlobalBhashiniText("Auto-Call Failed: $e")));
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: GlobalBhashiniText('SOS Activated! Auto-Calling and SMS sent to $smsSentCount contacts.'), backgroundColor: SafetyTheme.primaryRed),
    );"""

content = content.replace(target, replacement)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Rewrote SOS block")
