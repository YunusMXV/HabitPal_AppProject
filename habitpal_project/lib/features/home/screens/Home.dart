import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:habitpal_project/features/home/controller/home_controller.dart';
import 'package:habitpal_project/features/home/screens/create_habit.dart';
import 'package:habitpal_project/widgets/BottomNav.dart';
import 'package:habitpal_project/widgets/Habit_Tile.dart';
import 'package:habitpal_project/widgets/UI_Buttons.dart';
import 'package:routemaster/routemaster.dart';
import 'package:habitpal_project/utils/gradient_themes.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});
  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hi = ref.read(userProvider);
      ref.read(homeControllerProvider.notifier).getRandomMotivationalQuote(
            context,
            hi!.selectedQuotesCategories,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final quote = ref.watch(quoteProvider);

    final currentGradient = user!.selectedTheme == 'Original'
        ? GradientThemes.originalGradient
        : user.selectedTheme == 'Natural'
            ? GradientThemes.naturalGradient
            : GradientThemes.darkGradient;
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
            user.username,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: currentGradient),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250, // Adjust width as needed
                  height: 80, // Adjust height as needed
                  child: quote == null
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: Text(
                            quote.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Pacifico',
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
                const HabitTile(),
                reusableUIButton(context, "Create A New Habit", 0, () async {
                  Map<String, dynamic>? habitInfo = await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => PopScope(
                        onPopInvoked: (canPop) async {
                          Routemaster.of(context).pop();

                        },
                        child: const CreateHabitDialog(),),
                  );
                  if (habitInfo != null) {
                    // Do something with the gathered information
                    print('Habit Name: ${habitInfo['habitName']}');
                    print(
                        'Habit Description: ${habitInfo['habitDescription']}');
                    print('Habit Type: ${habitInfo['habitType']}');
                    print('Selected Days: ${habitInfo['selectedDays']}');
                    print('Habit Start Time: ${habitInfo['habitStartTime']}');
                  }
                }),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
