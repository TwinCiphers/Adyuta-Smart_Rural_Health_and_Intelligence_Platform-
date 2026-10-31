import re

code = open('lib/home_screen.dart', encoding='utf-8').read()

# Replace body: Container with body: Stack
code = re.sub(
    r'(body:\s+Container\()',
    r'body: Stack(\n            children: [\n              Container(',
    code,
    count=1
)

# Replace floatingActionButton with the stack closing and tooltip
code = re.sub(
    r'(\s+)(floatingActionButton:\s+FloatingActionButton\()',
    r'''\1  Positioned(
\1    bottom: 40,
\1    left: 0,
\1    right: 0,
\1    child: IgnorePointer(
\1      child: Center(
\1        child: Container(
\1          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
\1          decoration: BoxDecoration(
\1            color: Colors.white,
\1            borderRadius: BorderRadius.circular(20),
\1            boxShadow: [
\1              BoxShadow(
\1                color: Colors.black.withOpacity(0.15),
\1                blurRadius: 10,
\1                offset: const Offset(0, 4),
\1              ),
\1            ],
\1            border: Border.all(color: const Color(0xFF3366FF).withOpacity(0.2)),
\1          ),
\1          child: Row(
\1            mainAxisSize: MainAxisSize.min,
\1            children: [
\1              Image.asset('assets/images/aroha_logo.png', height: 20),
\1              const SizedBox(width: 8),
\1              const Text(
\1                'Hi, I am Aroha! How can I help you?',
\1                style: TextStyle(
\1                  color: Colors.black87,
\1                  fontWeight: FontWeight.w600,
\1                  fontSize: 13,
\1                ),
\1              ),
\1            ],
\1          ),
\1        ),
\1      ),
\1    ),
\1  ),
\1],
\1)\1\2''',
    code,
    count=1
)

open('lib/home_screen.dart', 'w', encoding='utf-8').write(code)
