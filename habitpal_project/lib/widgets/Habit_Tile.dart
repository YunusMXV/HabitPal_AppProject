import 'package:flutter/material.dart';

class Habit extends StatefulWidget {
  const Habit({super.key});

  @override
  State<Habit> createState() => _HabitState();
}

class _HabitState extends State<Habit> {
  @override
  Widget build(BuildContext context) {
    return const ListBody(
      children: [
        Column(
          children: [
            Card(
              child: ListTile(
                  minVerticalPadding: 20,
                  leading: CircleAvatar(
                    maxRadius: 40,
                    child: Text("Mon"),
                  ),
                  title: Text("Gym"),
                  subtitle: Text("11:30 Am"),
                  trailing: Icon(Icons.check_box)),
            ),
            Card(
              child: ListTile(
                  minVerticalPadding: 20,
                  leading: CircleAvatar(
                    maxRadius: 40,
                    child: Text("Mon"),
                  ),
                  title: Text("Swimming"),
                  subtitle: Text("1:00 pm"),
                  trailing: Icon(Icons.check_box)),
            ),
            Card(
              child: ListTile(
                  minVerticalPadding: 20,
                  leading: CircleAvatar(
                    maxRadius: 40,
                    child: Text("Mon"),
                  ),
                  title: Text("Running"),
                  subtitle: Text("5:00 pm"),
                  trailing: Icon(Icons.check_box)),
            ),
            Card(
              child: ListTile(
                  minVerticalPadding: 20,
                  leading: CircleAvatar(
                    maxRadius: 40,
                    child: Text("Mon"),
                  ),
                  title: Text("Reading"),
                  subtitle: Text("7:00 pm"),
                  trailing: Icon(Icons.check_box)),
            ),
            Card(
              child: ListTile(
                  minVerticalPadding: 20,
                  leading: CircleAvatar(
                    maxRadius: 40,
                    child: Text("Mon"),
                  ),
                  title: Text("Coding"),
                  subtitle: Text("9:00 pm"),
                  trailing: Icon(Icons.check_box)),
            ),
            Card(
              child: ListTile(
                  minVerticalPadding: 20,
                  leading: CircleAvatar(
                    maxRadius: 40,
                    child: Text("Mon"),
                  ),
                  title: Text("Dance"),
                  subtitle: Text("12:00 am "),
                  trailing: Icon(Icons.check_box)),
            )
          ],
        )
      ],
    );
  }
}

class Items {
  const Items(this.title, this.subtitle, this.day);

  final String title;
  final String subtitle;
  final String day;
}
