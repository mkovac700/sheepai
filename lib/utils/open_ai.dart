import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'scrapper.dart';

class ChatGPTService {
  bool isLoading = true;
  final String apiKey =
      "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";
  final String apiUrl = "https://api.openai.com/v1/chat/completions";

  Future<Map<String, dynamic>> getResponse(String url) async {
    final String scrappedContent = await scrapeWebContent(url);
    final Map<String, dynamic> scrappedData = jsonDecode(scrappedContent);
    final String articleContent = scrappedData['content'] ?? '';

    if (articleContent.isEmpty) {
      throw Exception('Article content is empty');
    }

    final String chunk = articleContent.substring(
        0, articleContent.length > 100000 ? 100000 : articleContent.length);
    print('chunk$chunk');
    final String prompt = """
    Your task is to process the following content and give output in JSON FORMAT, no explanations or additional content.
    Produce JSON format Strings that will be used to pass to widgets in Flutter. I have Table widget which accepts String headline and
    List<List<String>> columns; Give output following example below, you can give multiple tables in the output.
    Total number of rows in each column must be equal. It is up to you to decide how many rows you want to show in the table.
    {
    "mainTitle": "title - max 5 words",
    "mainShortDescription": "max 5 sentences page description",
    "lastUpdated": "example 2022-01-01",
    "table1": {
      "headline": "Example Table",
      "columns": [
        ["First Name", "John", "Jane"],
        ["Last Name", "Doe", "Smith"],
        ["Age", "30", "25"]
      ]
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
      final contentMap = content is List
          ? {for (var i = 0; i < content.length; i++) i.toString(): content[i]}
          : Map<String, dynamic>.from(content);
      print(contentMap);
      return {
        'mainTitle': contentMap['mainTitle'] ?? '',
        'mainShortDescription': contentMap['mainShortDescription'] ?? '',
        'lastUpdated': contentMap['lastUpdated'] ?? '',
        'tables': contentMap.keys
            .where((key) => key.startsWith('table'))
            .map((key) => {
                  'headline': contentMap[key]['headline'],
                  'columns': contentMap[key]['columns'],
                })
            .toList(),
      };
    } else if (response.statusCode == 429) {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error']['message'];
      if (errorMessage.contains('Rate limit reached')) {
        debugPrint('Rate limit exceeded. Stopping further requests.');
        return {};
      } else {
        throw Exception('Failed to load response: ${response.body}');
      }
    } else {
      throw Exception('Failed to load response: ${response.body}');
    }
  }
}
