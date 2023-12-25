import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    // IF LOG OUT I WANT TO HAVE THE INDEX AS 0
    final selectedIndex = ref.read(selectedIndexProvider);
    return CurvedNavigationBar(
      index: (selectedIndex),
      backgroundColor: Colors.transparent,
      color: Colors.white,
      animationDuration: const Duration(milliseconds: 0),
      animationCurve: Curves.fastOutSlowIn,
      onTap: (index) {
        ref.read(selectedIndexProvider.notifier).update((state) => index);

        // Change routes based on the selected index
        switch (index) {
          case 0:
            Routemaster.of(context).replace('/');
            ref.read(dateHistoryProvider.notifier).update(
              (state) => DateTime.now()
            );
            break;
          case 1:
            Routemaster.of(context).replace('/history');
            break;
          case 2:
            Routemaster.of(context).replace('/achievement');
            ref.read(dateHistoryProvider.notifier).update(
              (state) => DateTime.now()
            );
            break;
        }
      },
      items: const [
        Icon(Icons.home, color: Colors.black),
        Icon(Icons.history, color: Colors.black),
        Icon(Icons.rocket, color: Colors.black),
      ],
    );
  }
}