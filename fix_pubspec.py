import os
directories_to_scan = [
    r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\adyuta_main',
    r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\agri_module',
    r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\education_module',
    r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\governance_module',
    r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\health_module',
    r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\safety_module',
]

for directory in directories_to_scan:
    pubspec_path = os.path.join(directory, 'pubspec.yaml')
    if os.path.exists(pubspec_path):
        with open(pubspec_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        in_dev = False
        new_lines = []
        i = 0
        while i < len(lines):
            line = lines[i]
            if line.startswith('dev_dependencies:'):
                in_dev = True
            elif line.startswith('dependencies:') or (line.strip() and not line.startswith(' ')):
                if in_dev and not line.startswith('dev_dependencies:'):
                    in_dev = False
            
            if in_dev and 'bhashini_core:' in line:
                i += 2 # skip next line which is path: ../bhashini_core
                continue
            new_lines.append(line)
            i += 1
            
        with open(pubspec_path, 'w', encoding='utf-8') as f:
            f.writelines(new_lines)

