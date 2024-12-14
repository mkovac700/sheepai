import 'package:flutter/material.dart';
import '../utils/openAI.dart';

class UrlInputField extends StatelessWidget {
  const UrlInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Enter URL',
        border: OutlineInputBorder(),
      ),
      onSubmitted: (url) async {
        final chatGPTService = ChatGPTService();
        try {
          final response = await chatGPTService.getResponse(url);
          // Handle the response as needed
          print(response);
        } catch (e) {
          print('Error: $e');
        }
        // launchURL(context, url);
      },
    );
  }
}
