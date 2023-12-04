import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:habitpal_project/utils/color_utils.dart';
import 'package:routemaster/routemaster.dart';
// import 'package:habitpal_project/Screens/Home.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.black,
        animationDuration: const Duration(milliseconds: 200),
        onTap: (index) {
          print(index);
          switch (index) {
            case 0:
              Routemaster.of(context).replace('/');
              break;
            case 1:
              Routemaster.of(context).replace('/history');
              break;
            case 2:
              Routemaster.of(context).replace('/achievement');
            break;
          }
        },
        items: const [
          Icon(
            Icons.home,
            color: Colors.white
          ),
          Icon(
            Icons.history,
            color: Colors.white
          ),
          Icon(
            Icons.rocket,
            color: Colors.white
          ),
        ],
    );
  }
}