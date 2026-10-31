import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class RagService {
  static const String _searchUrl = 'http://16.170.143.195/retrieval/search';

  static Future<Map<String, dynamic>> getContext(String query) async {
    try {
      final response = await http.post(
        Uri.parse(_searchUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'query': query,
          'top_k': 3,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final hits = data['hits'] as List<dynamic>? ?? [];
        
        List<SourceRef> sources = [];
        String contextText = '';
        
        for (var hit in hits) {
          final body = hit['body'] as String?;
          final chunkId = hit['chunk_id'] as String?;
          final metadata = hit['metadata'] as Map<String, dynamic>?;
          if (body != null) {
            contextText += "\n---\n$body\n";
          }
          if (metadata != null && chunkId != null) {
            final title = metadata['title'] ?? metadata['source_document'] ?? 'Document';
            
            // Only add if not duplicate by title
            if (!sources.any((s) => s.title == title)) {
              sources.add(SourceRef(
                chunkId: chunkId,
                title: title.toString(),
                filename: metadata['source_document']?.toString(),
                url: metadata['source_url']?.toString(),
                domain: metadata['domain']?.toString(),
              ));
            }
          }
        }
        
        return {
          'context': contextText.trim(),
          'sources': sources,
        };
      }
    } catch (e) {
      print('RAG Error: $e');
    }
    
    return {'context': '', 'sources': <SourceRef>[]};
  }
}
