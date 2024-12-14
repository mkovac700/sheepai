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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(column1[0],
                      style: const TextStyle(color: Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(column2[0],
                      style: const TextStyle(color: Colors.black)),
                ),
              ],
            ),
            for (int i = 1; i < column1.length - 1; i++)
              TableRow(
                decoration: const BoxDecoration(color: Colors.white),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(column1[i],
                        style: const TextStyle(color: Colors.black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(column2[i],
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(column1[column1.length - 1],
                      style: const TextStyle(color: Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(column2[column2.length - 1],
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
