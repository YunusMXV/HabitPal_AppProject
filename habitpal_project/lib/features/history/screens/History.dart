import 'package:flutter/material.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:habitpal_project/features/home/controller/home_controller.dart';
import 'package:habitpal_project/utils/gradient_themes.dart';
import 'package:habitpal_project/widgets/BottomNav.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/widgets/History_Tile.dart';
import 'package:routemaster/routemaster.dart';

class History extends ConsumerStatefulWidget {
  const History({super.key});

  @override
  ConsumerState<History> createState() => _HistoryState();
}

class _HistoryState extends ConsumerState<History> {
  DateTime selectedDate = DateTime.now(); // Initialize with today's date

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final currentGradient =
        user!.selectedTheme == 'Original'
            ? GradientThemes.originalGradient
            : user.selectedTheme == 'Natural'
                ? GradientThemes.naturalGradient
                : GradientThemes.darkGradient; // Set dark theme gradient
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Routemaster.of(context).push('settings');
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "History",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: currentGradient
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.12, 20, 0
            ),
            child: Column(
              children: [
                // Date UI component
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(), // Allow dates before or equal to the current date
                    );
            
                    // if (pickedDate != null && pickedDate != selectedDate) {
                    //   setState(() {
                    //     selectedDate = pickedDate;
                    //   });
                    // }
                
                    if (pickedDate != null && pickedDate != selectedDate) {
                      selectedDate = pickedDate;
                      ref.read(dateHistoryProvider.notifier).update(
                        (state) => selectedDate
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.black),
                        const SizedBox(width: 8),
                        Text(
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // List of tiles generated from Firestore data
                const HistoryTile(),
                const SizedBox(height: 80,)
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}