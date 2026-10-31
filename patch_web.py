import os

files = [
    r'c:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\adyuta-chat\lib\ui\chat_screen.dart',
    r'c:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\adyuta-chat\lib\ui\message_bubble.dart',
    r'c:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\adyuta-chat\lib\ui\settings_sheet.dart',
    r'c:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\adyuta-chat\lib\widgets\sources_chip.dart'
]

for p in files:
    with open(p, 'r', encoding='utf-8') as f:
        content = f.read()
    
    content = content.replace('.withValues(alpha: 0.12)', '.withOpacity(0.12)')
    content = content.replace('.withValues(alpha: 0.16)', '.withOpacity(0.16)')
    content = content.replace('surfaceContainerHighest', 'surfaceVariant')
    content = content.replace('surfaceContainerHigh', 'surfaceVariant')
    content = content.replace('surfaceContainerLow', 'surface')
    content = content.replace("tooltip: 'Retrieval plus generation, no routing',", "")
    content = content.replace("tooltip: 'Same pipeline behind the connectivity router',", "")
    content = content.replace("initialValue: _locale,", "value: _locale,")
    
    with open(p, 'w', encoding='utf-8') as f:
        f.write(content)
    print('Updated:', os.path.basename(p))
