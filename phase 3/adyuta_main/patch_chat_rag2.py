code = open('lib/chat/ui/chat_screen.dart', encoding='utf-8').read()

code = code.replace("List<String> sourcesList = [];", "List<SourceRef> sourcesList = [];")
code = code.replace("sourcesList = List<String>.from(ragData['sources']);", "sourcesList = List<SourceRef>.from(ragData['sources']);")

open('lib/chat/ui/chat_screen.dart', 'w', encoding='utf-8').write(code)
