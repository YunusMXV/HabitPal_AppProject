import 'package:flutter/material.dart';
import 'package:habitpal_project/features/achievements/screens/barGraph/bar_graph.dart';
import 'package:habitpal_project/features/achievements/screens/pieChart/pie_chart.dart';
import 'package:habitpal_project/utils/color_utils.dart';
import 'package:habitpal_project/widgets/BottomNav.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
// import 'package:habitpal_project/widgets/BottomNav.dart';

class Achievement extends ConsumerStatefulWidget {
  const Achievement({super.key});

  @override
  ConsumerState<Achievement> createState() => _AchievementState();
}

class _AchievementState extends ConsumerState<Achievement> {
  List<double> weeklySummary = [
    15.0,
    30.0,
    45.0,
    55.0,
    95.0,
    100.0,
    25.0,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              final currentRoute = Routemaster.of(context).currentRoute;
              print(currentRoute);
              Routemaster.of(context).push('settings');
              print(currentRoute);
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Achievements",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexToColor("315b7d"), // #B4E1C5 to #ABCEAF to #B0DDD9
              hexToColor("1d4769"), // #315b7d to #1d4769 to #223F57
              hexToColor("223F57")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Row of Two Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard("Best Streak", "42"), // Replace "42" with your actual best streak number
                    ),
                    const SizedBox(width: 16), // Add spacing between the two cards if needed
                    Expanded(
                      child: _buildInfoCard("Current Streak", "15"), // Replace "15" with your actual current streak number
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Chart Cards
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Weekly Bar Chart",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 350,
                          height: 300,
                          child: MyBarGraph(
                            weeklySummary: weeklySummary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    width: 350,
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyPieChart(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildInfoCard(String title, String number) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              number,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
