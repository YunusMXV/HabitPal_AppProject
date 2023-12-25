import 'package:flutter/material.dart';
import 'package:habitpal_project/features/home/controller/home_controller.dart';
import 'package:intl/intl.dart'; // Import for DateFormat
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:habitpal_project/model/habit_model.dart';
import 'package:ionicons/ionicons.dart';

class HistoryTile extends ConsumerStatefulWidget {
  const HistoryTile({super.key});

  @override
  ConsumerState<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends ConsumerState<HistoryTile> {
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
    final selectedDate = ref.watch(dateHistoryProvider);
    String currentDay = DateFormat('EEEE').format(selectedDate!); // Get the current day

    return ListView.builder(
      padding: const EdgeInsets.all(0.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: user!.habits.length,
      itemBuilder: (context, index) {
        final habit = user.habits[index];

        // Check if the current day is in the habit's completion days
        if (habit.targetCompletionDays.contains(currentDay)) {
          var selectedProgress = habit.progressHistory.where((progress) {
            return progress.date.year == selectedDate.year &&
                progress.date.month == selectedDate.month &&
                progress.date.day == selectedDate.day;
          }).toList();
          return Card(
            color: Colors.yellowAccent,
            child: ListTile(
              minVerticalPadding: 20,
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                maxRadius: 40,
                child: 
                //Text(habit.targetCompletionDays.toString().substring(1, 4)),
                Text(currentDay.substring(0,3)),
              ),
              title: Text(habit.habitTitle),
              subtitle: Text(
                _formatTime12Hour(habit.completionDeadline),
              ),
              trailing: Container(
                  padding: EdgeInsets.all(10), // Adjust the padding as needed
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), // Add some border radius
                    color: Colors.transparent, // Set your desired background color
                  ),
                  child: Icon(
                    selectedProgress.isNotEmpty && selectedProgress[0].completed
                        ? Ionicons.checkmark_circle
                        : Ionicons.close_circle_outline,
                    size: 30, // Set your desired icon size
                    color: Colors.white, // Set your desired icon color
                ),
              ),
              onTap: () async {
                // ref.read(habitProvider.notifier).update((state) => habit);
                // Map<String, dynamic>? habitInfo = await showDialog(
                //   context: context,
                //   barrierDismissible: true,
                //   builder: (context) => PopScope(
                //     onPopInvoked: (canPop) async {
                //       Routemaster.of(context).pop();
                //     },
                //     child: const EditHabitDialog(),
                //   ),
                // );
              },
            ),
          );
        } else {
          // If the habit's completion days don't include the current day, return an empty container
          return Container();
        }
      },
    );
  }
}
