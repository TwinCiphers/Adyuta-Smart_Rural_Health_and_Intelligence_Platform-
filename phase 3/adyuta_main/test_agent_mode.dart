import 'lib/chat/services/agent_mode_service.dart';

void main() {
  print("--- Testing Agent Mode Local Matching ---");
  
  final testCases = [
    "hi",
    "hello",
    "goodbye",
    "thanks",
    "can you help me",
    "this is random text that should not match"
  ];
  
  for (final tc in testCases) {
    final response = AgentModeService.matchIntent(tc);
    if (response != null) {
      print("[MATCH] User: '$tc' -> Bot: '$response'");
    } else {
      print("[MISS] User: '$tc' -> No local match, routing to backend LLM.");
    }
  }
}
