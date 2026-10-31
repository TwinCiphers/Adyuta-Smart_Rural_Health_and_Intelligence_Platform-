import os
import re

bhashini_dir = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\bhashini_core'
if not os.path.exists(bhashini_dir):
    os.makedirs(os.path.join(bhashini_dir, 'lib'))

with open(os.path.join(bhashini_dir, 'pubspec.yaml'), 'w', encoding='utf-8') as f:
    f.write('''name: bhashini_core
description: A new Flutter package project.
version: 0.0.1
environment:
  sdk: ">=2.17.0 <4.0.0"
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.0
''')

with open(os.path.join(bhashini_dir, 'lib', 'bhashini_core.dart'), 'w', encoding='utf-8') as f:
    f.write('''library bhashini_core;
export 'src/bhashini_service.dart';
export 'src/bhashini_text.dart';
''')

os.makedirs(os.path.join(bhashini_dir, 'lib', 'src'), exist_ok=True)
