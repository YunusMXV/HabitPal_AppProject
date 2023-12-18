import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:habitpal_project/features/home/screens/create_habit.dart';
import 'package:habitpal_project/utils/color_utils.dart';
import 'package:habitpal_project/widgets/BottomNav.dart';
import 'package:habitpal_project/widgets/Habit_Tile.dart';
import 'package:habitpal_project/widgets/UI_Buttons.dart';
import 'package:routemaster/routemaster.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    //print(user);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Routemaster.of(context).push('/settings');
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
        centerTitle: true,
        title: Text(
          user!.username,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        )
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
            hexToColor("315b7d"), // #B4E1C5 to #ABCEAF to #B0DDD9
            hexToColor("1d4769"), // #315b7d to #1d4769 to #223F57
            hexToColor("223F57")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
            child: Column(
              children: [
                const Text(
                  "Get Good Sucker",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
                ),
                const Habit(),
                reusableUIButton(context, "Create A New Habit", 0, () async {
                  Map<String, dynamic>? habitInfo = await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => PopScope(
                      onPopInvoked: (canPop) async {
                        Routemaster.of(context).pop();
                      },
                      child: const CreateHabitDialog()
                    ),
                  );
                  if (habitInfo != null) {
                    // Do something with the gathered information
                    print('Habit Name: ${habitInfo['habitName']}');
                    print('Habit Description: ${habitInfo['habitDescription']}');
                    print('Habit Type: ${habitInfo['habitType']}');
                    print('Selected Days: ${habitInfo['selectedDays']}');
                    print('Habit Start Time: ${habitInfo['habitStartTime']}');
                  }
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
