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
            TableRow(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              children: [
                for (var column in columns)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(column[0],
                        style: const TextStyle(color: Colors.black)),
                  ),
              ],
            ),
            for (int i = 1; i < columns[0].length - 1; i++)
              TableRow(
                decoration: const BoxDecoration(color: Colors.white),
                children: [
                  for (var column in columns)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(column[i],
                          style: const TextStyle(color: Colors.black)),
                    ),
                ],
              ),
            TableRow(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10)),
              ),
              children: [
                for (var column in columns)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(column[column.length - 1],
                        style: const TextStyle(color: Colors.black)),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
