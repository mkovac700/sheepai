import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'scrapper.dart';

class ChatGPTService {
  bool isLoading = true;
  // final String apiKey = dotenv.env['API_KEY']!;
  final String apiKey =
      "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";
  // final String apiUrl = 'https://api.openai.com/v1/engines/davinci-codex/completions';
  final String apiUrl = "https://api.openai.com/v1/chat/completions";

  // ChatGPTService(this.apiKey);

  Future<Map<String, dynamic>> getResponse(String url) async {
    final String content = await scrapeWebContent(url);

    // Split content into smaller chunks to avoid exceeding token limit
    const int chunkSize = 5000; // Adjust chunk size to avoid rate limit
    final List<String> chunks = [];
    for (int i = 0; i < content.length; i += chunkSize) {
      chunks.add(content.substring(
          i, i + chunkSize > content.length ? content.length : i + chunkSize));
    }

    final Map<String, dynamic> result = {};
    for (var chunk in chunks) {
      if (!isLoading) return {}; // Exit if loading was cancelled
      print('Processing chunk: $chunk');
      final String prompt = """
      Your task is to process the following content and give output in JSON FORMAT, no explanations or additional content:
      in JSON FORMAT below, fill in the following fields on left side with the content from the page:
      {
        "mainTitle": "String (4 words max, analyze the content and provide a title)",
        "mainShortDescription": "String (short description of the page, max 4 sentences)",
        "lastUpdated": "String (when was the content last updated, set 'unknown' if not available)"
      }
      $chunk
      """;

      final List<Map<String, dynamic>> messages = [
        {
          "role": "user",
          "content": prompt,
        },
      ];

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-4",
          'messages': messages,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint(data.toString());
        final content = jsonDecode(data['choices'][0]['message']['content']);
        result.addAll(content);
      } else if (response.statusCode == 429) {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error']['message'];
        if (errorMessage.contains('Rate limit reached')) {
          debugPrint('Rate limit exceeded. Stopping further requests.');
          break; // Stop processing further chunks
        } else {
          throw Exception('Failed to load response: ${response.body}');
        }
      } else {
        throw Exception('Failed to load response: ${response.body}');
      }
    }

    return {
      'mainTitle': result['mainTitle'] ?? '',
      'mainShortDescription': result['mainShortDescription'] ?? '',
      'lastUpdated': result['lastUpdated'] ?? 'unknown',
    };
  }
}
