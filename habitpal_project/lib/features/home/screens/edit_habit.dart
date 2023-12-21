import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:habitpal_project/features/home/controller/home_controller.dart';
import 'package:habitpal_project/model/habit_model.dart';
import 'package:routemaster/routemaster.dart';

class EditHabitDialog extends ConsumerStatefulWidget {
  const EditHabitDialog({Key? key}) : super(key: key);
  @override
  EditHabitDialogState createState() => EditHabitDialogState();
}

class EditHabitDialogState extends ConsumerState<EditHabitDialog> {
  final TextEditingController habitNameController = TextEditingController();
  final TextEditingController habitDescriptionController = TextEditingController();

  String id = '';
  String habitName = '';
  String habitDescription = '';
  String habitType = 'Physical';
  DateTime habitStartTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0); // Initialize with 0:00

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
              Expanded(
                child: Text(
                  'Edit Habit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 30,
                  ),
                  onPressed: () async {
                    final confirmDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Are you sure?'),
                        content: const Text('Do you really want to delete this habit?'),
                        actions: [
                          TextButton(
                            onPressed: () =>             Routemaster.of(context).pop(), // Cancel
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true), // Confirm
                            child: const Text('Delete'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirmDelete!) {
                      // Proceed with deleting the habit
                      try {
                        // Call your function to delete the habit
                        ref.read(homeControllerProvider.notifier).deleteHabit(
                          context, 
                          id
                        );
                        Routemaster.of(context).pop();


                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Habit deleted successfully')),
                        );
                      } catch (error) {
                        // Handle any errors during deletion
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error deleting habit: $error')),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: habitNameController,
                onChanged: (value) {
                  setState(() {
                    habitName = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Habit Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: habitDescriptionController,
                onChanged: (value) {
                  setState(() {
                    habitDescription = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Habit Description'),
              ),
              const SizedBox(height: 10),
              // Dropdown for habit types
              DropdownButtonFormField<String>(
                value: habitType, // Set the initial value here
                decoration: const InputDecoration(labelText: 'Habit Type'),
                items: habitTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    habitType = value!;
                  });
                },
              ),
              const SizedBox(height: 10),
              const Text('Select Days:'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      children: [
                        for (var day in ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'])
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedDays.contains(day)) {
                                  selectedDays.remove(day);
                                } else {
                                  selectedDays.add(day);
                                }
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: selectedDays.contains(day) ? Colors.green : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.green),
                              ),
                              child: Text(
                                day[0],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: selectedDays.contains(day) ? Colors.white : Colors.black,
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
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 0, minute: 0), // Set initial time to 0:00
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                            child: child!,
                          );
                        },
                      );
      
                      if (selectedTime != null) {
                        setState(() {
                          habitStartTime = DateTime(
                            habitStartTime.year,
                            habitStartTime.month,
                            habitStartTime.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                        });
                      }
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
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (validateForm()) {
                  ref.read(homeControllerProvider.notifier).editHabit(
                    context, 
                    id,
                    habitName, 
                    habitDescription, 
                    habitType, 
                    selectedDays, 
                    habitStartTime,
                  );
                  Routemaster.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields and select at least one day.'),
                    ),
                  );
                }
              },
              child: const Text('Save'),
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