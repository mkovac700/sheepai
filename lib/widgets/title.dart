import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String mainHeadline;
  final String lastUpdate;
  final String shortDescription;

  const TitleWidget({
    super.key,
    required this.mainHeadline,
    required this.lastUpdate,
    required this.shortDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Make the container stretch from left to right
      padding: const EdgeInsets.symmetric(
          vertical: 16.0, horizontal: 50.0), // Big padding from left and right
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[800]!, Colors.blue[600]!], // Darker blue colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0), // Ensure rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mainHeadline,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            shortDescription,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomLeft, // Changed alignment to bottom left
            child: Text(
              lastUpdate,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
