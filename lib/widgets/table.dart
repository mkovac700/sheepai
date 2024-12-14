import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  final String headline;
  final List<List<String>> columns;

  const TableWidget({
    super.key,
    required this.headline,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headline,
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Table(
          border: TableBorder.all(color: Colors.black),
          children: [
            for (int i = 0; i < columns[0].length; i++)
              TableRow(
                decoration: const BoxDecoration(color: Colors.white),
                children: [
                  for (int j = 0; j < columns.length; j++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        columns[j][i],
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight:
                              j == 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
