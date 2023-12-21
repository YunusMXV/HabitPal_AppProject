import 'package:flutter/material.dart';
import 'package:habitpal_project/features/home/controller/home_controller.dart';
import 'package:habitpal_project/features/home/screens/edit_habit.dart';
import 'package:intl/intl.dart'; // Import for DateFormat
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:habitpal_project/model/habit_model.dart';
import 'package:routemaster/routemaster.dart';

class HabitTile extends ConsumerStatefulWidget {
  const HabitTile({super.key});

  @override
  ConsumerState<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends ConsumerState<HabitTile> {
  List<Habit> habitslist = [];
  @override
  void initState() {
    super.initState();
    habitslist = ref.read(userProvider)!.habits;
  }

  String _formatTime12Hour(DateTime time) {
    final hour = time.hour % 12; // Adjust for 12-hour format
    final minute = time.minute.toString().padLeft(2, '0'); // Ensure 2-digit minutes
    final amPm = time.hour >= 12 ? 'PM' : 'AM'; // Determine AM/PM
    return '$hour:$minute $amPm'; // Combine hour, minute, and AM/PM
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    //final habit = habitslist[0];
    return ListView.builder(
        padding: const EdgeInsets.all(0.0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: user!.habits.length, // Use user.habits directly
        itemBuilder: (context, index) {
          final habit = user.habits[index];
          return Card(
            color: Colors.yellowAccent,
                child: ListTile(
                  minVerticalPadding: 20,
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    maxRadius: 40,
                    child: Text(habit.targetCompletionDays.toString().substring(1, 4)), // Display first 3 letters of target days
                  ),
                  title: Text(habit.habitTitle),
                  subtitle: Text(
                    _formatTime12Hour(habit.completionDeadline), // Use the formatted time string
                  ),// Assuming completionDeadline is a DateTime
                  trailing: const Icon(Icons.check_box),
                  onTap: () async {
                    ref.read(habitProvider.notifier).update((state) => habit);
                    Map<String, dynamic>? habitInfo = await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => PopScope(
                      onPopInvoked: (canPop) async {
                        Routemaster.of(context).pop();
                      },
                      child: const EditHabitDialog()
                    ),
                  );
                  },
                ),
              );
        },
    );
  }
}
