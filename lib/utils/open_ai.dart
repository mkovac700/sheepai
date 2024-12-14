import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'scrapper.dart';

class ChatGPTService {
  bool isLoading = true;
  final String apiKey =
      "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";
  final String apiUrl = "https://api.openai.com/v1/chat/completions";

  Future<Map<String, dynamic>> getResponse(
      {required String url, required String language}) async {
    final String scrappedContent = await scrapeWebContent(url);
    final Map<String, dynamic> scrappedData = jsonDecode(scrappedContent);
    final String articleContent = scrappedData['content'] ?? '';

    if (articleContent.isEmpty) {
      throw Exception('Article content is empty');
    }

    final String chunk = articleContent.substring(
        0, articleContent.length > 100000 ? 100000 : articleContent.length);
    final String prompt = """
    Your task is to process the following content and give output in JSON FORMAT, no explanations or additional content.
    Content should be in $language language.
    Produce JSON format Strings that will be used to pass to widgets in Flutter. I have Table widget which accepts String headline and
    List<List<String>> columns, a HeadlineWithDescription widget which accepts a String headline and a String description, and a Chart widget which accepts a String headline, List<Map<String, dynamic>> data, and an integer interval.
    Total number of rows in each column must be equal. It is up to you to decide how many rows you want to show in the table.
    The first column should be the header of the table.
    You can give many tables, many headlines with descriptions, and many charts in the output. As much as you can.
    The headlineWithDescription1 field should have description with minimum 5 sentences. There should be minimum 10 headlineWithDescription1.
    Give structured output following JSON example below. You can add more tables and charts.
    Every data type inside headline or table should be String, only charts can accept integer.
    Provide as much tables and charts as posssible.
    Don't go out of the frame of provided JSON example.
    {
      "mainTitle": "title - max 5 words",
      "mainShortDescription": "max 5 sentences page description",
      "lastUpdated": "example 2022-01-01",
      "tables": [
        {
          "headline": "Example Table",
          "columns": [
            ["First Name", "John", "Jane"],
            ["Last Name", "Doe", "Smith"],
            ["Age", "30", "25"]
          ]
        }
      ],
      "charts": [
        {
          "headline": "Example Chart",
          "data": [
            {"label": "Category 1", "value": 10},
            {"label": "Category 2", "value": 20}
          ],
        }
      ],
      "headlineWithDescription1": {
        "headline": "Example Headline",
        "description": "This is an example description."
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
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": messages,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final content = jsonDecode(data['choices'][0]['message']['content']);
      final contentMap = content is List
          ? {for (var i = 0; i < content.length; i++) i.toString(): content[i]}
          : Map<String, dynamic>.from(content);
      print('chart${contentMap['charts']}');
      print('table${contentMap['tables']}');
      return {
        'mainTitle': contentMap['mainTitle'] ?? '',
        'mainShortDescription': contentMap['mainShortDescription'] ?? '',
        'lastUpdated': contentMap['lastUpdated'] ?? '',
        'tables': (contentMap['tables'] as List)
            .map((table) => {
                  'headline': table['headline'],
                  'columns': table['columns'],
                })
            .toList(),
        'charts': (contentMap['charts'] as List)
            .map((chart) => {
                  'headline': chart['headline'],
                  'data': chart['data'],
                  'interval': chart['interval'],
                })
            .toList(),
        'headlinesWithDescriptions': contentMap.keys
            .where((key) => key.startsWith('headlineWithDescription'))
            .map((key) => {
                  'headline': contentMap[key]['headline'],
                  'description': contentMap[key]['description'],
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
