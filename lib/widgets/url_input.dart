import 'package:flutter/material.dart';
import '../utils/helper.dart';

class UrlInputField extends StatelessWidget {
  const UrlInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Enter URL',
        border: OutlineInputBorder(),
      ),
      onSubmitted: (url) {
        launchURL(context, url);
      },
    );
  }
}
