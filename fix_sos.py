import re
file_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\safety_module\lib\features\sos\sos_screen.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

target = r"GlobalBhashiniText('Tap \${3 - _sosTapCount} more times rapidly to trigger Auto SOS.')"
replacement = "GlobalBhashiniText('Tap ${3 - _sosTapCount} more times rapidly to trigger Auto SOS.')"

content = content.replace(target, replacement)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Fixed SOS tap string")
