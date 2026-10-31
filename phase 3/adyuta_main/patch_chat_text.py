code = open('lib/chat/ui/chat_screen.dart', encoding='utf-8').read()

# Fix TextField
code = code.replace("controller: _input,\n                                    maxLines: 4,", "controller: _input,\n                                    style: const TextStyle(color: Colors.black87, fontSize: 16),\n                                    maxLines: 4,")

# Fix hint text
code = code.replace("hintText: 'Message Aroha...',", "hintText: 'Message Aroha...',\n                                      hintStyle: const TextStyle(color: Colors.black54),")

# Fix popup texts
code = code.replace("Text('Camera')", "Text('Camera', style: TextStyle(color: Colors.black87))")
code = code.replace("Text('Photos')", "Text('Photos', style: TextStyle(color: Colors.black87))")
code = code.replace("Text('Document')", "Text('Document', style: TextStyle(color: Colors.black87))")

open('lib/chat/ui/chat_screen.dart', 'w', encoding='utf-8').write(code)
