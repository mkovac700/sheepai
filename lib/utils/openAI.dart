import 'dart:convert';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ChatGPTService {
  // final String apiKey = dotenv.env['API_KEY']!;
  final String apiKey =
      "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";
  // final String apiUrl = 'https://api.openai.com/v1/engines/davinci-codex/completions';
  final String apiUrl = "https://api.openai.com/v1/chat/completions";

  // ChatGPTService(this.apiKey);

  Future<Map<String, dynamic>> getResponse(String url) async {
    final webScraper = WebScraper();
    final result = await webScraper.scrape(
      url: Uri.parse(url),
      configMap: {
        'default': [
          Config(
            parsers: {
              'content': [
                Parser(
                  id: 'html',
                  parent: ['_root'],
                  type: ParserType.element,
                  selector: ['html'],
                ),
              ],
            },
            urlTargets: [
              UrlTarget(
                name: 'default',
                where: ['/'],
              ),
            ],
          ),
        ],
      },
      configIndex: 0,
      debug: true,
    );

    final Object content = result['html'] ?? '';

    final String prompt = """
    Your task is to process the following content and extract the following structured data:
    $content
    Make sure to return data as follows:
    - mainTitle: String (title of the page)
    - mainShortDescription: String (short description of the page, max 4 sentences)
    - lastUpdated: String (when was the content last updated, set 'unknown' if not available)
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
      final content = data['choices'][0]['message']['content'];
      final lines =
          content.split('\n').where((line) => line.trim().isNotEmpty).toList();
      final Map<String, String> result = {};
      for (var line in lines) {
        final parts = line.split(':');
        if (parts.length == 2) {
          result[parts[0].trim()] = parts[1].trim();
        }
      }
      return {
        'mainTitle': result['mainTitle'] ?? '',
        'mainShortDescription': result['mainShortDescription'] ?? '',
        'lastUpdated': result['lastUpdated'] ?? 'unknown',
      };
    } else {
      throw Exception('Failed to load response: ${response.body}');
    }
  }
}
