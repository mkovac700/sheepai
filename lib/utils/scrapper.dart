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
      'customAttributes': {
        'mainTitle': {
          'type': 'string',
          'description': 'The title of the page',
        },
        'mainShortDescription': {
          'type': 'string',
          'description':
              'A short description of the page, must differ from the mainTitle',
        },
        'lastUpdated': {
          'type': 'string',
          'description': 'The last updated time of the page',
        },
        'pageContent': {
          'type': 'string',
          'description': 'Whole content of the page',
        },
      }
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final extractedData = data['customAttributes'] ?? {};
    // Correctly print mainTitle
    return jsonEncode(extractedData);
  } else {
    throw Exception('Failed to load web content: ${response.body}');
  }
}
