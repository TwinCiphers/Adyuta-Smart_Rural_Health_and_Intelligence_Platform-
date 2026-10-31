code = open('lib/chat/api/groq_service.dart', encoding='utf-8').read()

# Replace jsonDecode(response.body) with jsonDecode(utf8.decode(response.bodyBytes))
code = code.replace("jsonDecode(response.body)", "jsonDecode(utf8.decode(response.bodyBytes))")

open('lib/chat/api/groq_service.dart', 'w', encoding='utf-8').write(code)
