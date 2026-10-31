code = open('lib/chat/ui/chat_screen.dart', encoding='utf-8').read()

code = code.replace("import '../api/groq_service.dart';", "import '../api/groq_service.dart';\nimport '../api/rag_service.dart';")

import_block = """
      final replyText = await GroqService.askGroq(
        text,
        history: history,
        base64Image: img.isNotEmpty ? img : null,
      );
"""

new_block = """
      String contextStr = '';
      List<String> sourcesList = [];
      if (img.isEmpty) {
        final ragData = await RagService.getContext(text);
        contextStr = ragData['context'];
        sourcesList = List<String>.from(ragData['sources']);
      }
      
      final replyText = await GroqService.askGroq(
        text,
        history: history,
        base64Image: img.isNotEmpty ? img : null,
        contextText: contextStr,
      );
"""
code = code.replace(import_block, new_block)

code = code.replace("meta: const MessageMeta(sources: [])", "meta: MessageMeta(sources: sourcesList)")

open('lib/chat/ui/chat_screen.dart', 'w', encoding='utf-8').write(code)
