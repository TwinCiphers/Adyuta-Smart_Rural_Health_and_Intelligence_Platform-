import re
path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\health_module\lib\features\first_aid\screens\first_aid_detail_screen.dart'
with open(path, 'r', encoding='utf-8') as f:
    code = f.read()

code = code.replace("return SoftBackgroundLayout(\n      child: Padding(", "return SoftBackgroundLayout(\n      hasScrollBody: true,\n      child: Padding(")

with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
