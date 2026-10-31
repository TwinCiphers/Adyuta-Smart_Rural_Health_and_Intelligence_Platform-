import os

file_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\adyuta_main\lib\services\bhashini_service.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

target = '''                                    Text(
                                      lang['native']!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? const Color(0xFF19326A) : Colors.black87,
                                      ),
                                    ),'''

replacement = '''                                    Flexible(
                                      child: Text(
                                        lang['native']!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected ? const Color(0xFF19326A) : Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),'''

content = content.replace(target, replacement)

target2 = '''                                Text(
                                  lang['name']!,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: isSelected ? const Color(0xFF19326A).withOpacity(0.8) : Colors.grey.shade600,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),'''
replacement2 = '''                                Text(
                                  lang['name']!,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: isSelected ? const Color(0xFF19326A).withOpacity(0.8) : Colors.grey.shade600,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),'''

content = content.replace(target2, replacement2)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Fixed layout overflows.")
