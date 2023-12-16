import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPieChart extends ConsumerWidget {
  const MyPieChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Text(
          "Habit Type",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: 20,
                color: Colors.purple,
              ),
              PieChartSectionData(
                value: 20,
                color: Colors.red,
              ),
              PieChartSectionData(
                value: 20,
                color: Colors.green,
              ),
              PieChartSectionData(
                value: 20,
                color: Colors.yellow,
              ),
            ],
          ),
        ),
      ],
    );
  }
}