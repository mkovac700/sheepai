import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> scrapeWebContent(String url) async {
  const apiKey = '5231b2555074451fb3c833711f511404';
  const apiUrl = 'https://api.zyte.com/v1/extract';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:'))}',
    },
    body: jsonEncode({
      'url': url,
      'article': true,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final articleContent = data['article']['articleBody'] ?? '';
    if (articleContent.isEmpty) {
      print('Article content is empty. Response data: ${response.body}');
    }
    return jsonEncode({'content': articleContent});
  } else {
    print('Failed to load web content: ${response.body}');
    throw Exception('Failed to load web content: ${response.body}');
  }
}
