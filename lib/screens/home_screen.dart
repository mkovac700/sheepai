import 'package:flutter/material.dart';
import '../widgets/table.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableWidget(
              headline: 'Example Table',
              column1: ['Governing entity', 'Another entity'],
              column2: ['Canadian Revenue Agency', 'Another agency'],
            ),
            // ...additional widgets or content...
          ],
        ),
      ),
    );
  }
}
