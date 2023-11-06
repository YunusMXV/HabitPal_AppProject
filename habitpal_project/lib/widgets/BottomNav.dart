import 'package:flutter/material.dart';
import 'package:habitpal_project/Screens/settings.dart';
// import 'package:habitpal_project/Screens/Home.dart';
import 'package:habitpal_project/Screens/Achievments.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
              onPressed: () {
                // ignore: prefer_const_constructors
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
              icon: const Icon(Icons.settings)),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
              onPressed: () {
                // ignore: prefer_const_constructors
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
    ));
  }
}
