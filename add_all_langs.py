import os
import re

translations = {
    'bn': {
        'Live Data Mode': 'লাইভ ডেটা মোড',
        'Connected & Synced': 'সংযুক্ত এবং সিঙ্ক করা হয়েছে',
        'Bharat Citizen Portal': 'ভারত সিটিজেন পোর্টাল',
        'Smart Rural Health, Agri & Governance': 'স্মার্ট গ্রামীণ স্বাস্থ্য, কৃষি এবং প্রশাসন',
        'PHC Linked': 'PHC যুক্ত',
        'Setup Profile': 'প্রোফাইল সেটআপ করুন',
        '3 emergency contacts': '৩টি জরুরি পরিচিতি',
        'Recent Activity': 'সাম্প্রতিক কার্যকলাপ',
        'Education': 'শিক্ষা',
        'Learn': 'শিখুন',
        'Governance': 'প্রশাসন',
        'Explore Services': 'পরিষেবা অন্বেষণ করুন'
    },
    'te': {
        'Live Data Mode': 'లైవ్ డేటా మోడ్',
        'Connected & Synced': 'కనెక్ట్ చేయబడింది మరియు సింక్ చేయబడింది',
        'Bharat Citizen Portal': 'భారత్ సిటిజన్ పోర్టల్',
        'Smart Rural Health, Agri & Governance': 'స్మార్ట్ గ్రామీణ ఆరోగ్యం, వ్యవసాయం మరియు పరిపాలన',
        'PHC Linked': 'PHC లింక్ చేయబడింది',
        'Setup Profile': 'ప్రొఫైల్ సెటప్ చేయండి',
        '3 emergency contacts': '3 అత్యవసర పరిచయాలు',
        'Recent Activity': 'ఇటీవలి కార్యాచరణ',
        'Education': 'విద్య',
        'Learn': 'నేర్చుకోండి',
        'Governance': 'పరిపాలన',
        'Explore Services': 'సేవలను అన్వేషించండి'
    },
    'mr': {
        'Live Data Mode': 'लाइव्ह डेटा मोड',
        'Connected & Synced': 'कनेक्ट केलेले आणि सिंक केलेले',
        'Bharat Citizen Portal': 'भारत सिटीझन पोर्टल',
        'Smart Rural Health, Agri & Governance': 'स्मार्ट ग्रामीण आरोग्य, कृषी आणि प्रशासन',
        'PHC Linked': 'PHC जोडलेले',
        'Setup Profile': 'प्रोफाइल सेट अप करा',
        '3 emergency contacts': '3 आणीबाणी संपर्क',
        'Recent Activity': 'अलीकडील क्रियाकलाप',
        'Education': 'शिक्षण',
        'Learn': 'शिका',
        'Governance': 'प्रशासन',
        'Explore Services': 'सेवा एक्सप्लोर करा'
    },
    'ta': {
        'Live Data Mode': 'நேரடி தரவு முறை',
        'Connected & Synced': 'இணைக்கப்பட்டு ஒத்திசைக்கப்பட்டது',
        'Bharat Citizen Portal': 'பாரத் குடிமக்கள் போர்டல்',
        'Smart Rural Health, Agri & Governance': 'ஸ்மார்ட் கிராமப்புற சுகாதாரம், விவசாயம் மற்றும் நிர்வாகம்',
        'PHC Linked': 'PHC இணைக்கப்பட்டது',
        'Setup Profile': 'சுயவிவரத்தை அமைக்கவும்',
        '3 emergency contacts': '3 அவசரகால தொடர்புகள்',
        'Recent Activity': 'சமீபத்திய செயல்பாடு',
        'Education': 'கல்வி',
        'Learn': 'கற்க',
        'Governance': 'நிர்வாகம்',
        'Explore Services': 'சேவைகளை ஆராயுங்கள்'
    },
    'gu': {
        'Live Data Mode': 'લાઇવ ડેટા મોડ',
        'Connected & Synced': 'કનેક્ટેડ અને સિંક કરેલ',
        'Bharat Citizen Portal': 'ભારત સિટીઝન પોર્ટલ',
        'Smart Rural Health, Agri & Governance': 'સ્માર્ટ ગ્રામીણ આરોગ્ય, કૃષિ અને શાસન',
        'PHC Linked': 'PHC લિંક કરેલ',
        'Setup Profile': 'પ્રોફાઇલ સેટઅપ કરો',
        '3 emergency contacts': '3 કટોકટી સંપર્કો',
        'Recent Activity': 'તાજેતરની પ્રવૃત્તિ',
        'Education': 'શિક્ષણ',
        'Learn': 'શીખો',
        'Governance': 'શાસન',
        'Explore Services': 'સેવાઓનું અન્વેષણ કરો'
    },
    'kn': {
        'Live Data Mode': 'ಲೈವ್ ಡೇಟಾ ಮೋಡ್',
        'Connected & Synced': 'ಸಂಪರ್ಕಗೊಂಡಿದೆ ಮತ್ತು ಸಿಂಕ್ ಮಾಡಲಾಗಿದೆ',
        'Bharat Citizen Portal': 'ಭಾರತ್ ಸಿಟಿಜನ್ ಪೋರ್ಟಲ್',
        'Smart Rural Health, Agri & Governance': 'ಸ್ಮಾರ್ಟ್ ಗ್ರಾಮೀಣ ಆರೋಗ್ಯ, ಕೃಷಿ ಮತ್ತು ಆಡಳಿತ',
        'PHC Linked': 'PHC ಸಂಪರ್ಕಿಸಲಾಗಿದೆ',
        'Setup Profile': 'ಪ್ರೊಫೈಲ್ ಸೆಟಪ್ ಮಾಡಿ',
        '3 emergency contacts': '3 ತುರ್ತು ಸಂಪರ್ಕಗಳು',
        'Recent Activity': 'ಇತ್ತೀಚಿನ ಚಟುವಟಿಕೆ',
        'Education': 'ಶಿಕ್ಷಣ',
        'Learn': 'ಕಲಿಯಿರಿ',
        'Governance': 'ಆಡಳಿತ',
        'Explore Services': 'ಸೇವೆಗಳನ್ನು ಅನ್ವೇಷಿಸಿ'
    },
    'ml': {
        'Live Data Mode': 'തത്സമയ ഡാറ്റ മോഡ്',
        'Connected & Synced': 'ബന്ധിപ്പിക്കുകയും സിൻക്രോണൈസ് ചെയ്യുകയും ചെയ്തു',
        'Bharat Citizen Portal': 'ഭാരത് സിറ്റിസൺ പോർട്ടൽ',
        'Smart Rural Health, Agri & Governance': 'സ്മാർട്ട് റൂറൽ ഹെൽത്ത്, അഗ്രി ആൻഡ് ഗവേണൻസ്',
        'PHC Linked': 'PHC ബന്ധിപ്പിച്ചു',
        'Setup Profile': 'പ്രൊഫൈൽ സജ്ജമാക്കുക',
        '3 emergency contacts': '3 അടിയന്തര കോൺടാക്റ്റുകൾ',
        'Recent Activity': 'സമീപകാല പ്രവർത്തനം',
        'Education': 'വിദ್ಯಾഭ്യാസം',
        'Learn': 'പഠിക്കുക',
        'Governance': 'ഭരണം',
        'Explore Services': 'സേവനങ്ങൾ പര്യവേക്ഷണം ചെയ്യുക'
    },
    'od': {
        'Live Data Mode': 'ଲାଇଭ୍ ଡାଟା ମୋଡ୍',
        'Connected & Synced': 'ସଂଯୁକ୍ତ ଏବଂ ସିଙ୍କ୍ ହୋଇଛି',
        'Bharat Citizen Portal': 'ଭାରତ ନାଗରିକ ପୋର୍ଟାଲ୍',
        'Smart Rural Health, Agri & Governance': 'ସ୍ମାର୍ଟ ଗ୍ରାମୀଣ ସ୍ୱାସ୍ଥ୍ୟ, କୃଷି ଏବଂ ଶାସନ',
        'PHC Linked': 'PHC ଲିଙ୍କ୍ ହୋଇଛି',
        'Setup Profile': 'ପ୍ରୋଫାଇଲ୍ ସେଟଅପ୍ କରନ୍ତୁ',
        '3 emergency contacts': '3 ଜରୁରୀକାଳୀନ ସମ୍ପର୍କ',
        'Recent Activity': 'ସାମ୍ପ୍ରତିକ କାର୍ଯ୍ୟକଳାପ',
        'Education': 'ଶିକ୍ଷା',
        'Learn': 'ଶିଖନ୍ତୁ',
        'Governance': 'ଶାସନ',
        'Explore Services': 'ସେବାଗୁଡିକ ଅନୁସନ୍ଧାନ କରନ୍ତୁ'
    },
    'pa': {
        'Live Data Mode': 'ਲਾਈਵ ਡੇਟਾ ਮੋਡ',
        'Connected & Synced': 'ਕਨੈਕਟ ਕੀਤਾ ਅਤੇ ਸਿੰਕ ਕੀਤਾ ਗਿਆ',
        'Bharat Citizen Portal': 'ਭਾਰਤ ਸਿਟੀਜ਼ਨ ਪੋਰਟਲ',
        'Smart Rural Health, Agri & Governance': 'ਸਮਾਰਟ ਪੇਂਡੂ ਸਿਹਤ, ਖੇਤੀਬਾੜੀ ਅਤੇ ਸ਼ਾਸਨ',
        'PHC Linked': 'PHC ਲਿੰਕ ਕੀਤਾ ਗਿਆ',
        'Setup Profile': 'ਪ੍ਰੋਫਾਈਲ ਸੈੱਟਅੱਪ ਕਰੋ',
        '3 emergency contacts': '3 ਐਮਰਜੈਂਸੀ ਸੰਪਰਕ',
        'Recent Activity': 'ਹਾਲੀਆ ਗਤੀਵਿਧੀ',
        'Education': 'ਸਿੱਖਿਆ',
        'Learn': 'ਸਿੱਖੋ',
        'Governance': 'ਸ਼ਾਸਨ',
        'Explore Services': 'ਸੇਵਾਵਾਂ ਦੀ ਪੜਚੋਲ ਕਰੋ'
    },
    'as': {
        'Live Data Mode': 'লাইভ ডেটা মোড',
        'Connected & Synced': 'সংযুক্ত আৰু চিঙ্ক কৰা হৈছে',
        'Bharat Citizen Portal': 'ভাৰত নাগৰিক পৰ্টেল',
        'Smart Rural Health, Agri & Governance': 'স্মাৰ্ট গ্ৰাম্য স্বাস্থ্য, কৃষি আৰু প্ৰশাসন',
        'PHC Linked': 'PHC সংযুক্ত',
        'Setup Profile': 'প্ৰফাইল ছেটআপ কৰক',
        '3 emergency contacts': '৩ টা জৰুৰীকালীন যোগাযোগ',
        'Recent Activity': 'শেহতীয়া কাৰ্যকলাপ',
        'Education': 'শিক্ষা',
        'Learn': 'শিকক',
        'Governance': 'প্ৰশাসন',
        'Explore Services': 'সেৱাসমূহ অন্বেষণ কৰক'
    }
}

file_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\bhashini_core\lib\src\bhashini_service.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

for lang_code, strings_dict in translations.items():
    pattern = rf"('{lang_code}':\s*\{{)(.*?)(\}},)"
    match = re.search(pattern, content, re.DOTALL)
    
    if match:
        block_start = match.group(1)
        block_content = match.group(2)
        block_end = match.group(3)
        
        extra_content = "\n"
        for k, v in strings_dict.items():
            if f"'{k}'" not in block_content:
                extra_content += f"      '{k}': '{v}',\n"
                
        new_block = block_start + block_content + extra_content + "    " + block_end
        content = content.replace(match.group(0), new_block)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
    
print("Injected all translations.")
