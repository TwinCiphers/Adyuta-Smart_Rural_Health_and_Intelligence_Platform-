import re
path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\health_module\lib\core\widgets\soft_background_layout.dart'
with open(path, 'r', encoding='utf-8') as f:
    code = f.read()

replacement = """          // The main content
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: hasScrollBody
                  ? child
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: child,
                    ),
            ),
          ),"""

code = re.sub(r'// The main content\s*SafeArea\([\s\S]*?\),[\s\S]*?\),', replacement, code)

with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
