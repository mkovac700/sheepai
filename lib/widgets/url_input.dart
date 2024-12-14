import 'package:flutter/material.dart';

class UrlInputField extends StatelessWidget {
  final Function(String) onSubmitted;

  const UrlInputField({super.key, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Enter URL',
        border: OutlineInputBorder(),
      ),
      onSubmitted: onSubmitted,
    );
  }
}
