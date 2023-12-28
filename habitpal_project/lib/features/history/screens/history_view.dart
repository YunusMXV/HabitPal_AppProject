import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/features/home/controller/home_controller.dart';
import 'package:routemaster/routemaster.dart';

class HistoryHabitDialog extends ConsumerStatefulWidget {
  const HistoryHabitDialog({Key? key}) : super(key: key);
  @override
  HistoryHabitDialogState createState() => HistoryHabitDialogState();
}

class HistoryHabitDialogState extends ConsumerState<HistoryHabitDialog> {
  final TextEditingController habitNameController = TextEditingController();
  final TextEditingController habitDescriptionController =
      TextEditingController();

  String id = '';
  String habitName = '';
  String habitDescription = '';
  String habitType = 'Physical';
  DateTime habitStartTime = DateTime(2024, 1, 31, 0, 0); // Initialize with 0:00

  Set<String> selectedDays = <String>{};

  // List of available habit types
  final List<String> habitTypes = [
    'Physical',
    'Mental',
    'Productivity',
    'Social',
    'Creativity',
    'Financial',
    'Spiritual',
    'Passion',
    'Personal',
  ];
  final List habitIcons = [
    Icons.directions_run,
    Icons.lightbulb_outline,
    Icons.work,
    Icons.people,
    Icons.brush,
    Icons.attach_money,
    Icons.favorite,
    Icons.self_improvement,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();

    final selectedHabit = ref.read(habitProvider);

    if (selectedHabit != null) {
      setState(() {
        id = selectedHabit.habitId;
        habitName = selectedHabit.habitTitle;
        habitDescription = selectedHabit.description;
        habitType = selectedHabit.category;
        habitStartTime = selectedHabit.completionDeadline;
        selectedDays = selectedHabit.targetCompletionDays;
        habitNameController.text = habitName;
        habitDescriptionController.text = habitDescription;
      });

      print(selectedHabit);
    } else {
      print('Habit with ID $selectedHabit.habitId not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'History Habit',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              readOnly: true,
              controller: habitNameController,
              onChanged: (value) {
                setState(() {
                });
              },
              decoration: const InputDecoration(
                  labelText: 'Habit Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            const SizedBox(height: 15),
            TextField(
              readOnly: true,
              controller: habitDescriptionController,
              onChanged: (value) {
                setState(() {
                });
              },
              decoration: const InputDecoration(
                  labelText: 'Habit Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            const SizedBox(height: 15),
            // Dropdown for habit types
            DropdownButtonFormField<String>(
              value: habitType, // Set the initial value here
              decoration: const InputDecoration(
                  labelText: 'Habit Type',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              items: habitTypes.map((type) {
                return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(habitIcons[habitTypes.indexOf(type)]),
                        const SizedBox(width: 10),
                        Text(type),
                      ],
                    ));
              }).toList(),
              onTap: null,
              onChanged: null,
            ),
            const SizedBox(height: 10),
            const Text('Select Days:'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    children: [
                      for (var day in [
                        'Sunday',
                        'Monday',
                        'Tuesday',
                        'Wednesday',
                        'Thursday',
                        'Friday',
                        'Saturday'
                      ])
                        GestureDetector(
                          onTap: () {
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selectedDays.contains(day)
                                  ? Colors.green
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Text(
                              day[0],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: selectedDays.contains(day)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Habit Start Time:'),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                      },
                  child: Text(
                    '${habitStartTime.hour.toString().padLeft(2, '0')}:${habitStartTime.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Routemaster.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  bool validateForm() {
    return habitName.isNotEmpty &&
        habitDescription.isNotEmpty &&
        habitDescription.split(' ').length <= 50 &&
        selectedDays.isNotEmpty;
  }
}