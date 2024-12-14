import 'package:chatgpt_test/widgets/title.dart';
import 'package:flutter/material.dart';
import '../widgets/table.dart';
import '../widgets/headline_with_description.dart';
import '../data/dummy_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'Sheep',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold, // Make the text bolder
              ),
            ),
            Text(
              'AI_',
              style: TextStyle(
                color: Color(0xFF00FF00), // More fluorescent green color
                fontWeight: FontWeight.bold, // Make the text bolder
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[900], // Dark grey color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleWidget(
              mainHeadline: headline,
              lastUpdate: lastUpdated,
              shortDescription: overviewText,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: double.infinity, // Make the width equal
                    child: HeadlineWithDescription(
                      headline: headline,
                      description: overviewText,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity, // Make the width equal
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[800], // Darker blue color
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const TableWidget(
                      headline: keyEntitiesTitle,
                      column1: column1,
                      column2: column2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(
                    width: double.infinity, // Make the width equal
                    child: HeadlineWithDescription(
                      headline: detailsTitle,
                      description: detailsText,
                    ),
                  ),
                  // ...additional widgets or content...
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
