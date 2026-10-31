import os
import re

db_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\safety_module\lib\core\db\safety_database.dart'
helpline_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\safety_module\lib\core\services\helpline_service.dart'
guide_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\safety_module\lib\core\services\safety_guide_service.dart'
incident_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\safety_module\lib\core\services\incident_service.dart'
contact_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\safety_module\lib\core\services\contact_service.dart'

# 1. Update SafetyDatabase to have a singleton
with open(db_path, 'r', encoding='utf-8') as f:
    db_content = f.read()

if 'static final SafetyDatabase instance =' not in db_content:
    target = 'class SafetyDatabase extends _$SafetyDatabase {'
    replacement = '''class SafetyDatabase extends _$SafetyDatabase {
  static final SafetyDatabase instance = SafetyDatabase._internal();
  SafetyDatabase._internal() : super(_openConnection());'''
    db_content = db_content.replace(target, replacement)
    
    # fix the original constructor if anyone is calling it, but we can just leave it or rename it
    target2 = 'SafetyDatabase() : super(_openConnection());'
    replacement2 = 'SafetyDatabase() : super(_openConnection()); // Deprecated, use instance'
    db_content = db_content.replace(target2, replacement2)

    with open(db_path, 'w', encoding='utf-8') as f:
        f.write(db_content)

# 2. Update all services to use SafetyDatabase.instance
services = [helpline_path, guide_path, incident_path, contact_path]
for path in services:
    if os.path.exists(path):
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Pattern to replace the getter
        # static SafetyDatabase? _sharedDb;
        # static SafetyDatabase get _db => _sharedDb ??= SafetyDatabase();
        # OR static SafetyDatabase get _db => SafetyDatabase();
        
        # Just safely find `SafetyDatabase get _db` and replace it
        new_content = re.sub(
            r'static SafetyDatabase\?? _sharedDb;\s*static SafetyDatabase get _db => _sharedDb \?\?= SafetyDatabase\(\);',
            'static SafetyDatabase get _db => SafetyDatabase.instance;',
            content,
            flags=re.DOTALL
        )
        new_content = re.sub(
            r'static SafetyDatabase get _db => SafetyDatabase\(\);',
            'static SafetyDatabase get _db => SafetyDatabase.instance;',
            new_content
        )
        
        if new_content != content:
            with open(path, 'w', encoding='utf-8') as f:
                f.write(new_content)
print("Fixed DB Singleton")
