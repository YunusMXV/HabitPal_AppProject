import 'package:flutter/material.dart';
import 'package:habitpal_project/widgets/achievement/barGraph/bar_graph.dart';
import 'package:habitpal_project/widgets/achievement/pieChart/pie_chart.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:habitpal_project/features/home/controller/home_controller.dart';
import 'package:habitpal_project/utils/gradient_themes.dart';
import 'package:habitpal_project/widgets/BottomNav.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/widgets/achievement/info_card.dart';
import 'package:routemaster/routemaster.dart';

class Achievement extends ConsumerStatefulWidget {
  const Achievement({super.key});

  @override
  ConsumerState<Achievement> createState() => _AchievementState();
}

class _AchievementState extends ConsumerState<Achievement> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hi = ref.read(userProvider);
      if(hi!.habits.isNotEmpty)
      {
        ref.read(homeControllerProvider.notifier).calculateWeeklyProgress(
          context, 
          hi.habits,
        );
        ref.read(homeControllerProvider.notifier).calculateWeeklyTypes(
          context,
          hi.habits,
        );
        ref.read(homeControllerProvider.notifier).calculateStreak(
          context, 
          hi.habits,
        );
      }
      else
      {
        ref.read(weeklyProgressProvider.notifier).update((state) => [0.0,0.0,0.0,0.0,0.0,0.0,0.0]);
        ref.read(categoryProgressProvider.notifier).update((state) => [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final List<double> weeklySummary = ref.watch(weeklyProgressProvider);
    final List<double> categorySummary = ref.watch(categoryProgressProvider);
    //List<double> categorySummary = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
    //print("Weekly Summary: $weeklySummary");
    final currentGradient = user!.selectedTheme == 'Original'
        ? GradientThemes.originalGradient
        : user.selectedTheme == 'Natural'
            ? GradientThemes.naturalGradient
            : GradientThemes.darkGradient; // Set dark theme gradient
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Routemaster.of(context).push('settings');
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
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(gradient: currentGradient),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: infoCard("Best Streak",
                          user.maxStreak.toString()), // Replace "42" with your actual best streak number
                    ),
                    const SizedBox(
                        width:
                            16), // Add spacing between the two cards if needed
                    Expanded(
                      child: infoCard("Current Streak",
                          user.currentStreak.toString()), // Replace "15" with your actual current streak number
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
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
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
                      child: MyPieChart(
                        categorySummary: categorySummary,
                      ),
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
}
