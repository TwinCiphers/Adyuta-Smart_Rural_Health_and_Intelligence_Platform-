code = open('lib/home_screen.dart', encoding='utf-8').read()

import_block = """          body: Container("""
new_block = """          body: Stack(
            children: [
              Container("""
code = code.replace(import_block, new_block)

end_block = """                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton("""
new_end_block = """                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: const Color(0xFF3366FF).withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/aroha_logo.png', height: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Hi, I am Aroha! How can I help you?',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton("""
code = code.replace(end_block, new_end_block)

open('lib/home_screen.dart', 'w', encoding='utf-8').write(code)
