import 'dart:convert';
import 'package:chatgpt_test/data/dummy_text.dart';
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
    final String scrappedContent = await scrapeWebContent(url);
    final Map<String, dynamic> scrappedData =
        jsonDecode(scrappedContent)['values'];
    // Split content into smaller chunks to avoid exceeding token limit
    const int chunkSize = 5000; // Adjust chunk size to avoid rate limit
    final List<String> chunks = [];
    for (int i = 0; i < scrappedContent.length; i += chunkSize) {
      chunks.add(scrappedContent.substring(
          i,
          i + chunkSize > scrappedContent.length
              ? scrappedContent.length
              : i + chunkSize));
    }

    final Map<String, dynamic> result = {};
    for (var chunk in chunks) {
      if (!isLoading) return {}; // Exit if loading was cancelled
      final String prompt = """
      Your task is to process the following content and give output in JSON FORMAT, no explanations or additional content.
      Produce JSON format Strings that will be used to pass to widgets in Flutter. I have Table widget which accepts String headline and
      List<List<String>> columns; Give output following example below, you can give multiple tables in the output.
      Total number of rows in each column must be equal. It is up to you to decide how many rows you want to show in the table.
      {
      "table1": {
        "headline": "Example Table",
        "columns": [
          ["First Name", "John", "Jane"],
          ["Last Name", "Doe", "Smith"],
          ["Age", "30", "25"]
        ]
      }
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
      'mainTitle': scrappedData['mainTitle'] ?? 'No Title',
      'mainShortDescription':
          scrappedData['mainShortDescription'] ?? 'No Description',
      'lastUpdated': scrappedData['lastUpdated'] ?? 'Unknown',
      'tables': result.isNotEmpty ? result : {},
    };
  }
}
