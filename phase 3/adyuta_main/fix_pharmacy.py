import re
path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\health_module\lib\features\pharmacy\repositories\pharmacy_repo.dart'
with open(path, 'r', encoding='utf-8') as f:
    code = f.read()
code = re.sub(r',\s*priceInr:\s*0\.0', '', code)
code = re.sub(r'PurchaseLink\(platform:', 'PurchaseLink(id: 0, platform:', code)
with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
