import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/utils/color_utils.dart';
import 'package:routemaster/routemaster.dart';
import 'package:habitpal_project/features/home/controller/home_controller.dart';

class BottomNav extends ConsumerStatefulWidget {
  const BottomNav({super.key});

  @override
  ConsumerState<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.read(selectedIndexProvider);
    return CurvedNavigationBar(
        index: (selectedIndex),
        backgroundColor: Colors.transparent,
        color: Colors.black,
        animationDuration: const Duration(milliseconds: 1000),
        onTap: (index) {
        ref.read(selectedIndexProvider.notifier).update((state) => index);

        // Change routes based on the selected index
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
            color: Color.fromARGB(255, 59, 48, 48)
          ),
        ],
    );
  }
}