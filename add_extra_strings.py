from deep_translator import GoogleTranslator
import re

missing_strings = [
    'Live Data Mode',
    'Connected & Synced',
    'Bharat Citizen Portal',
    'Smart Rural Health, Agri & Governance',
    'PHC Linked',
    'Setup Profile',
    '3 emergency contacts',
    'Recent Activity',
    'Education',
    'Learn',
    'Governance',
]

lang_map = {
    'hi': 'hi',
    'bn': 'bn',
    'te': 'te',
    'mr': 'mr',
    'ta': 'ta',
    'gu': 'gu',
    'kn': 'kn',
    'ml': 'ml',
    'od': 'or', # odia code in google is usually 'or'
    'pa': 'pa',
    'as': 'as', # assamese
}

file_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\bhashini_core\lib\src\bhashini_service.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

for code, google_code in lang_map.items():
    print(f"Translating for {code}...")
    translator = GoogleTranslator(source='en', target=google_code)
    
    # find the block for this language in the dict
    pattern = rf"('{code}':\s*\{{)(.*?)(\}},)"
    match = re.search(pattern, content, re.DOTALL)
    if match:
        block_start = match.group(1)
        block_content = match.group(2)
        block_end = match.group(3)
        
        extra_content = "\n"
        for string in missing_strings:
            if f"'{string}'" not in block_content:
                try:
                    translated = translator.translate(string)
                    # escape quotes
                    translated = translated.replace("'", "\\'")
                    extra_content += f"      '{string}': '{translated}',\n"
                except Exception as e:
                    print(f"Error translating {string}: {e}")
                    
        new_block = block_start + block_content + extra_content + "    " + block_end
        content = content.replace(match.group(0), new_block)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Injected translated strings.")
