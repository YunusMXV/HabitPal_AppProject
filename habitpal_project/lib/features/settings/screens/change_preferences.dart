import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:habitpal_project/utils/gradient_themes.dart';
import 'package:habitpal_project/widgets/UI_Buttons.dart';
import 'package:routemaster/routemaster.dart';

class ChangePreferences extends ConsumerStatefulWidget {
  const ChangePreferences({Key? key}) : super(key: key);

  @override
  _ChangePreferencesState createState() => _ChangePreferencesState();
}

class _ChangePreferencesState extends ConsumerState<ChangePreferences> {
  List<String> initialSelectedCategories = [];
  String initialType = "";
  @override
  void initState() {
    super.initState();
    initialSelectedCategories = ref.read(userProvider)!.selectedQuotesCategories;
    initialType = ref.read(userProvider)!.selectedTheme;
  }
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final currentGradient =
        user!.selectedTheme == 'Original'
            ? GradientThemes.originalGradient
            : user.selectedTheme == 'Natural'
                ? GradientThemes.naturalGradient
                : GradientThemes.darkGradient; // Set dark theme gradient

    // List of motivational types
    final List<String> motivationalTypes = [
      "Exploring",
      "Kindness",
      "Listening",
      "Giving",
      "Optimism",
      "Resilience",
      "Helping",
    ];

    // List of theme types
    final List<String> themeTypes = [
      "Original",
      "Natural",
      "Dark",
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Change Preferences',       
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            final currentRoute = Routemaster.of(context).currentRoute;
            print(currentRoute);
            Routemaster.of(context).pop();
            print(currentRoute);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
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
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Choose Motivational Quote Types",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                // Use Wrap to display buttons in rows
                Wrap(
                // Adjust spacing and alignment as needed
                spacing: 10, // Adjust horizontal spacing between buttons
                runSpacing: 10, // Adjust vertical spacing between rows
                alignment: WrapAlignment.start, // Align buttons to the left
                children: motivationalTypes.map((type) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (initialSelectedCategories.length > 2 && initialSelectedCategories.contains(type)) {
                          initialSelectedCategories.remove(type);
                        } else {
                          initialSelectedCategories.add(type);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: initialSelectedCategories.contains(type)
                          ? Colors.green
                          : Colors.red,
                    ),
                    child: Text(
                      type,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  height: 1,
                  indent: 0.5,
                  endIndent: 0.5,
                  thickness: 0.263,
                  color: Colors.white, // Adjust the color to fit your design
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Select Theme",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                // Use Wrap to display buttons in rows
                Wrap(
                  // ... your existing spacing and alignment settings
                  spacing: 10, // Adjust horizontal spacing between buttons
                  runSpacing: 10, // Adjust vertical spacing between rows
                  alignment: WrapAlignment.start, // Align buttons to the left
                  children: themeTypes.map((type) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (initialType == type) {
                            // If the current theme is already selected, handle deselection (if needed)
                          } else {
                            initialType = type;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: type == initialType ? Colors.green : Colors.red,
                      ),
                      child: Text(
                        type,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  height: 1,
                  indent: 0.5,
                  endIndent: 0.5,
                  thickness: 0.263,
                  color: Colors.white, // Adjust the color to fit your design
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Set Reminders",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableUIButton(context, "Confirm", 0, () async {
                  try {
                    ref.read(authControllerProvider.notifier).changeMotivationalQuotes(
                      context, 
                      initialSelectedCategories
                    );

                    ref.read(authControllerProvider.notifier).changeType(
                      context, 
                      initialType,
                    );
                    
                    Navigator.pop(context);
                  } catch (e) {
                    print("Error: $e");
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
