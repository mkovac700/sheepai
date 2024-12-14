import 'package:flutter/material.dart';

class HeadlineText extends StatelessWidget {
  final String text;

  const HeadlineText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blue[900],
      ),
    );
  }
}

class DescriptionText extends StatelessWidget {
  final String text;

  const DescriptionText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }
}

// Dummy text to be used inside text_widgets
const String dummyHeadline = 'Dummy Headline';
const String dummyDescription =
    'This is a dummy description text for testing purposes.';
