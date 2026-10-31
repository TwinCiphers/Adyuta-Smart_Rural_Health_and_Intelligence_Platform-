import os

file_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\bhashini_core\lib\src\bhashini_service.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace any wrong interpolation string with regex
import re
new_content = re.sub(r"Uri\.parse\('https://api\.mymemory\.translated\.net/get\?q=.*?'\);",
                     r"Uri.parse('https://api.mymemory.translated.net/get?q=${Uri.encodeComponent(text)}&langpair=en|${_currentLanguageCode}');",
                     content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(new_content)

print("Fixed")
