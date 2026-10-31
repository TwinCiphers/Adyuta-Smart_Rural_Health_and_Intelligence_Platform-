import os
import re

directories_to_scan = [
    r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\adyuta_main',
    r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\agri_module',
    r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\education_module',
    r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\governance_module',
    r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\health_module',
    r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\safety_module',
]

text_pattern = re.compile(r'\bText\(')

for directory in directories_to_scan:
    if not os.path.exists(directory):
        continue
    
    # 1. Add dependency to pubspec.yaml
    pubspec_path = os.path.join(directory, 'pubspec.yaml')
    if os.path.exists(pubspec_path):
        with open(pubspec_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        if 'bhashini_core:' not in content:
            # find dependencies block
            content = content.replace('dependencies:\n', 'dependencies:\n  bhashini_core:\n    path: ../bhashini_core\n')
            with open(pubspec_path, 'w', encoding='utf-8') as f:
                f.write(content)
                
    # 2. Replace Text( with GlobalBhashiniText( in all .dart files
    lib_path = os.path.join(directory, 'lib')
    if not os.path.exists(lib_path):
        continue
        
    for root, _, files in os.walk(lib_path):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    file_content = f.read()
                
                if text_pattern.search(file_content):
                    # Replace const Text( with const GlobalBhashiniText(
                    new_content = text_pattern.sub('GlobalBhashiniText(', file_content)
                    
                    if 'import \'package:bhashini_core/bhashini_core.dart\';' not in new_content:
                        # find first import and inject it
                        import_match = re.search(r'import .*;', new_content)
                        if import_match:
                            idx = import_match.start()
                            new_content = new_content[:idx] + "import 'package:bhashini_core/bhashini_core.dart';\n" + new_content[idx:]
                        else:
                            new_content = "import 'package:bhashini_core/bhashini_core.dart';\n" + new_content

                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                        
print('Done!')
