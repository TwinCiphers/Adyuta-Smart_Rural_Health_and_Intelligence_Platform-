import re

file_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\safety_module\lib\features\sos\sos_screen.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

target = r"""    setState(() {
      _sosActive = true;
    });

    String coords = _currentPosition != null \? 'https://maps\.google\.com/\?q=\$\{_currentPosition!\.latitude\},\$\{_currentPosition!\.longitude\}' : 'Location unavailable';
    String messageBody = "EMERGENCY \(Adyuta Safety\): I need immediate help\. My last known location is: \$coords";

    // 1\. Auto Live Tracking Enable"""

# We'll replace it with a block that awaits location.
# Note: I need to use literal string replacement for safety. Let's just use string replacement, no regex.
