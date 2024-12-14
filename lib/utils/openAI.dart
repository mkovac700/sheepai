import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class ChatGPTService {
  // final String apiKey = dotenv.env['API_KEY']!;
  final String apiKey =
      "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";
  //final String apiUrl = 'https://api.openai.com/v1/engines/davinci-codex/completions';
  final String apiUrl = "https://api.openai.com/v1/chat/completions";

  //ChatGPTService(this.apiKey);

  Future<Map<String, dynamic>> getResponse(String url) async {
    debugPrint('apiKey: $apiKey');

    // Hardcoded prompt specifying the exact type of data needed
    final String prompt = """
    Extract the following structured data from the URL: $url
    - headline: String
    - overviewTitle: String
    - overviewText: String
    - keyEntitiesTitle: String
    - column1: List<String>
    - column2: List<String>
    - detailsTitle: String
    - detailsText: String
    - lastUpdated: String (leave blank if not available)
    """;

    // Build the messages payload
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
        "model": "gpt-4o-mini", // Ensure the model supports vision inputs
        'messages': messages,
        'max_tokens': 500,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint(data.toString());
      // Assuming the response is a structured map
      return Map<String, dynamic>.from(
          data['choices'][0]['message']['content']);
    } else {
      throw Exception('Failed to load response${response.body}');
    }
  }
}
