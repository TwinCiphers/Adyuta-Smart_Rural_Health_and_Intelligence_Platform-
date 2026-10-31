import re
path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\governance_module\lib\data\gov_data.dart'
with open(path, 'r', encoding='utf-8') as f:
    code = f.read()

# Remove the invalid category parameter
code = re.sub(r",\s*category:\s*'[^']*'", "", code)

with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
