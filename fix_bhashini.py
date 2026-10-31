import os
import re

file_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\adyuta_main\lib\services\bhashini_service.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Add import if missing
if "import 'package:bhashini_core/bhashini_core.dart';" not in content:
    content = "import 'package:bhashini_core/bhashini_core.dart';\n" + content

# Modify setLanguage to call GlobalBhashiniService
target_str = '''  void setLanguage(String langCode) {
    if (_currentLanguageCode == langCode) return;
    _currentLanguageCode = langCode;
    notifyListeners();
  }'''

replacement_str = '''  void setLanguage(String langCode) {
    if (_currentLanguageCode == langCode) return;
    _currentLanguageCode = langCode;
    GlobalBhashiniService.instance.setLanguage(langCode);
    notifyListeners();
  }'''

content = content.replace(target_str, replacement_str)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Restored and modified safely.")
