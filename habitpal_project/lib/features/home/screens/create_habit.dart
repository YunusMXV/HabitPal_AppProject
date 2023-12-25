import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/features/home/controller/home_controller.dart';
import 'package:routemaster/routemaster.dart';

class CreateHabitDialog extends ConsumerStatefulWidget {
  const CreateHabitDialog({Key? key}) : super(key: key);
  @override
  CreateHabitDialogState createState() => CreateHabitDialogState();
}

class CreateHabitDialogState extends ConsumerState<CreateHabitDialog> {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AlertDialog(
          title: const Text('Create a New Habit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    habitName = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Habit Name'),
              ),
              const SizedBox(height: 10),
              TextField(
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
                value: habitType,
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
                  ref.read(homeControllerProvider.notifier).createHabit(
                    context, 
                    habitName, 
                    habitDescription, 
                    habitType, 
                    selectedDays, 
                    habitStartTime,
                  );
                  Navigator.pop(context, {
                    'habitName': habitName,
                    'habitDescription': habitDescription,
                    'habitType': habitType,
                    'selectedDays': selectedDays.toList(),
                    'habitStartTime': habitStartTime,
                  });
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