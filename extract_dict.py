import os
import re

source_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\adyuta_main\lib\services\bhashini_service.dart'
dest_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\bhashini_core\lib\src\bhashini_service.dart'

with open(source_path, 'r', encoding='utf-8') as f:
    source_content = f.read()

match = re.search(r'(static const Map<String, Map<String, String>> _localTranslations = \{.*?\};)', source_content, re.DOTALL)
if match:
    dict_str = match.group(1)
    
    with open(dest_path, 'r', encoding='utf-8') as f:
        dest_content = f.read()
        
    # insert the dictionary into GlobalBhashiniService
    class_def = "class GlobalBhashiniService extends ChangeNotifier {"
    dest_content = dest_content.replace(class_def, class_def + "\n  " + dict_str)
    
    # modify the translate method to use it
    target_cache_lookup = "if (_cache[_currentLanguageCode] != null && _cache[_currentLanguageCode]!.containsKey(text)) {"
    
    new_cache_lookup = """
    if (_localTranslations[_currentLanguageCode] != null && _localTranslations[_currentLanguageCode]!.containsKey(text)) {
      return _localTranslations[_currentLanguageCode]![text]!;
    }
    """ + target_cache_lookup
    
    dest_content = dest_content.replace(target_cache_lookup, new_cache_lookup)
    
    with open(dest_path, 'w', encoding='utf-8') as f:
        f.write(dest_content)
    print("Injected local translations into global service.")
else:
    print("Could not find dictionary.")
