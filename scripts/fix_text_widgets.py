import os
import re

def process_dart_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Avoid modifying bhashini_core itself
    if 'bhashini_core' in filepath or 'fix_text_widgets.py' in filepath:
        return

    # Count how many \bText( we have
    matches = re.findall(r'\bText\(', content)
    
    if not matches:
        return

    # Replace \bText( with \bGlobalBhashiniText(
    new_content = re.sub(r'\bText\(', 'GlobalBhashiniText(', content)

    # If changes made, ensure import
    if new_content != content:
        if "package:bhashini_core/bhashini_core.dart" not in new_content:
            # Add import at the top
            lines = new_content.split('\n')
            import_line = "import 'package:bhashini_core/bhashini_core.dart';"
            for i, line in enumerate(lines):
                if line.startswith('import '):
                    lines.insert(i, import_line)
                    break
            else:
                lines.insert(0, import_line)
            new_content = '\n'.join(lines)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {filepath} ({len(matches)} replacements)")

if __name__ == '__main__':
    base_dir = 'phase 3'
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file.endswith('.dart'):
                process_dart_file(os.path.join(root, file))
