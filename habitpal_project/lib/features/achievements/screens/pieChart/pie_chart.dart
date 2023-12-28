import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPieChart extends ConsumerWidget {
  final List categorySummary;
  // ignore: prefer_const_constructors_in_immutables
  const MyPieChart({
    super.key,
    required this.categorySummary,
  });

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
                  value: categorySummary[0],
                  color: Colors.teal,
                  showTitle: true,
                  title: 'Physical',
                  titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                  radius: 60,
                ),
              PieChartSectionData(
                value: categorySummary[1],
                color: Colors.blue,
                showTitle: true,
                title: 'Mental',
                titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                radius: 60,
              ),
              PieChartSectionData(
                value: categorySummary[2],
                color: Colors.lightGreen,
                showTitle: true,
                title: 'Productivity',
                titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                radius: 60,
              ),
              PieChartSectionData(
                value: categorySummary[3],
                color: Colors.orange,
                showTitle: true,
                title: 'Social',
                titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                radius: 60,
              ),
              PieChartSectionData(
                value: categorySummary[4],
                color: Colors.purple,
                showTitle: true,
                title: 'Creativity',
                titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                radius: 60,
              ),
              PieChartSectionData(
                value: categorySummary[5],
                color: Colors.red,
                showTitle: true,
                title: 'Financial',
                titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                radius: 60,
              ),
              PieChartSectionData(
                value: categorySummary[6],
                color: Colors.amber,
                showTitle: true,
                title: 'Spiritual',
                titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                radius: 60,
              ),
              PieChartSectionData(
                value: categorySummary[7],
                color: Colors.indigo,
                showTitle: true,
                title: 'Passion',
                titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                radius: 60,
              ),
              PieChartSectionData(
                value: categorySummary[8],
                color: Colors.deepOrange,
                showTitle: true,
                title: 'Personal',
                titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                radius: 60,
              ),
            ],
            borderData: FlBorderData(show: false),
            centerSpaceRadius: 80,
            sectionsSpace: 0,
            //centerSpaceColor: Colors.white,
          ),
        ),
      ],
    );
  }
}