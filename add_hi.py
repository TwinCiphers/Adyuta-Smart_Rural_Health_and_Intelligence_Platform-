import os
import re

extra_hi = {
    'Live Data Mode': 'लाइव डेटा मोड',
    'Connected & Synced': 'कनेक्टेड और सिंक किया गया',
    'Bharat Citizen Portal': 'भारत नागरिक पोर्टल',
    'Smart Rural Health, Agri & Governance': 'स्मार्ट ग्रामीण स्वास्थ्य, कृषि और प्रशासन',
    'PHC Linked': 'PHC लिंक्ड',
    'Setup Profile': 'प्रोफ़ाइल सेट करें',
    '3 emergency contacts': '3 आपातकालीन संपर्क',
    'Recent Activity': 'हाल की गतिविधि',
    'Education': 'शिक्षा',
    'Learn': 'सीखें',
    'Governance': 'प्रशासन',
    'Explore Services': 'सेवाएं एक्सप्लोर करें'
}

file_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\bhashini_core\lib\src\bhashini_service.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

pattern = r"('hi':\s*\{)(.*?)(\},)"
match = re.search(pattern, content, re.DOTALL)

if match:
    block_start = match.group(1)
    block_content = match.group(2)
    block_end = match.group(3)
    
    extra_content = "\n"
    for k, v in extra_hi.items():
        if f"'{k}'" not in block_content:
            extra_content += f"      '{k}': '{v}',\n"
            
    new_block = block_start + block_content + extra_content + "    " + block_end
    content = content.replace(match.group(0), new_block)
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
    print("Injected Hindi translations.")
else:
    print("Hindi block not found.")
