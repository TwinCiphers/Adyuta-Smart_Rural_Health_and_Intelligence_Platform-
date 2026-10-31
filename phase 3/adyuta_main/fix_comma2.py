import re
code = open('lib/home_screen.dart', encoding='utf-8').read()
code = re.sub(r'\]\s*,\s*\n\s*\)\s*floatingActionButton:', '],\n          ),\n          floatingActionButton:', code)
open('lib/home_screen.dart', 'w', encoding='utf-8').write(code)
