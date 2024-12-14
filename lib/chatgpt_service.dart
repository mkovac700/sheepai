import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class ChatGPTService {
 // final String apiKey = dotenv.env['API_KEY']!;
  final String apiKey = "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";
  //final String apiUrl = 'https://api.openai.com/v1/engines/davinci-codex/completions';
final String apiUrl = "https://api.openai.com/v1/chat/completions";

  //ChatGPTService(this.apiKey);

  Future<String> getResponse(String prompt) async {
    debugPrint('apiKey: ' + apiKey);

    //final List<String> messages = [];

    final String text = "";

    // Build the messages payload
    final List<Map<String, dynamic>> messages = [
      {
        "role": "user",
        "content": [
          {
            "type": "text",
            "text": prompt,
          },
          {"type": "text", "text": text},

        ],
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
        //'prompt': prompt,
        'messages': messages,
        'max_tokens': 100,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint(data.toString());
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('Failed to load response' + response.body);
    }
  }
}