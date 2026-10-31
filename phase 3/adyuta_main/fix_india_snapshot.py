import re
path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\governance_module\lib\core\widgets\india_snapshot_card.dart'
with open(path, 'r', encoding='utf-8') as f:
    code = f.read()

code = code.replace('height: 120,', 'height: 160,')
code = code.replace('width: 140,', 'width: 160,')

rep = """Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                ind.value,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),"""

code = code.replace("""Text(
                            ind.value,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),""", rep)

with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
