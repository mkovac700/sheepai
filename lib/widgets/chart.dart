import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartWidget extends StatelessWidget {
  final String headline;
  final List<Map<String, dynamic>> data;

  const ChartWidget({
    super.key,
    required this.headline,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            headline,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SizedBox(
          height: 700, // Increased height from 300 to 400
          child: BarChart(
            BarChartData(
              barGroups: data
                  .map(
                    (datum) => BarChartGroupData(
                      x: data.indexOf(datum),
                      barRods: [
                        BarChartRodData(
                          toY: datum['value'].toDouble(),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                  .toList(),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(
                        value.toString(),
                        style: const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(
                        value.toString(),
                        style: const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(
                        data[value.toInt()]['label'],
                        style: const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
