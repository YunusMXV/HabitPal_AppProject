import 'package:flutter/material.dart';
// import 'package:habitpal_project/Screens/Home.dart';
// import 'package:habitpal_project/widgets/BottomNav.dart';
import 'package:habitpal_project/widgets/Habit_Tile.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) => const Habit(),
      ),
      
    );
  }
}
