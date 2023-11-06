import 'package:flutter/material.dart';
import 'package:habitpal_project/Screens/Achievments.dart';
import 'package:habitpal_project/Screens/History.dart';
import 'package:habitpal_project/Screens/settings.dart';
import 'package:habitpal_project/widgets/Habit_Tile.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // ignore: prefer_const_constructors
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const History(),
                ),
              );
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) => const Habit(),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
            ),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Acheivment(),
                    ),
                  );
                },
                icon: const Icon(Icons.rocket)),
            label: 'Acheivments',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/Setting');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/achievement');
          }
        },
      ),
    );
  }
}
