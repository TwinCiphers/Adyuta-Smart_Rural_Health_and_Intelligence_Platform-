import os

file_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\safety_module\lib\features\sos\sos_screen.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

target = """    setState(() {
      _sosActive = true;
    });

    String coords = _currentPosition != null ? 'https://maps.google.com/?q=${_currentPosition!.latitude},${_currentPosition!.longitude}' : 'Location unavailable';
    String messageBody = "EMERGENCY (Adyuta Safety): I need immediate help. My last known location is: $coords";"""

replacement = """    setState(() {
      _sosActive = true;
    });

    if (_currentPosition == null) {
      try {
        _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, timeLimit: const Duration(seconds: 4));
      } catch (e) {
        try {
          _currentPosition = await Geolocator.getLastKnownPosition();
        } catch (_) {}
      }
    }

    String coords = _currentPosition != null ? 'https://maps.google.com/?q=${_currentPosition!.latitude},${_currentPosition!.longitude}' : 'Location unavailable';
    String messageBody = "EMERGENCY (Adyuta Safety): I need immediate help. My last known location is: $coords";"""

if target in content:
    content = content.replace(target, replacement)
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
    print("Fixed location fallback")
else:
    print("Target not found. Doing fuzzy search.")
