import os
import glob
import re

count = 0
for file in glob.glob(r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\**\*.dart', recursive=True):
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()
        if r'\${' in content:
            print(f'Found escaped interpolation in {file}')
            count += 1
if count == 0:
    print('No escaped string interpolations found.')
