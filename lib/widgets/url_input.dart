import 'package:flutter/material.dart';

class UrlInputField extends StatefulWidget {
  final Function(String) onSubmitted;

  const UrlInputField({super.key, required this.onSubmitted});

  @override
  _UrlInputFieldState createState() => _UrlInputFieldState();
}

class _UrlInputFieldState extends State<UrlInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Enter URL',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            widget.onSubmitted(_controller.text);
          },
        ),
      ),
      style: const TextStyle(
        color: Colors.white, // Change text color here
      ),
      onSubmitted: widget.onSubmitted,
    );
  }
}