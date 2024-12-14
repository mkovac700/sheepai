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
        title: const Text('Canada E-Invoicing and Digital Reporting'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeadlineWithDescription(
                headline: headline,
                description: overviewText,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[900],
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
              const HeadlineWithDescription(
                headline: detailsTitle,
                description: detailsText,
              ),
              // ...additional widgets or content...
            ],
          ),
        ),
      ),
    );
  }
}
