import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  final String headline;
  final List<String> column1;
  final List<String> column2;

  const TableWidget({
    super.key,
    required this.headline,
    required this.column1,
    required this.column2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headline,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Table(
          border: TableBorder.all(),
          children: [
            for (int i = 0; i < column1.length; i++)
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(column1[i]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(column2[i]),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
