import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:habitpal_project/features/home/controller/home_controller.dart';
import 'package:habitpal_project/utils/gradient_themes.dart';
import 'package:habitpal_project/widgets/settings_tile.dart';
import 'package:ionicons/ionicons.dart';
import 'package:routemaster/routemaster.dart';

//import 'package:habitpal_project/Screens/Home.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();

}

class _SettingsState extends ConsumerState<Settings> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final currentGradient =
        user!.selectedTheme == 'Original'
            ? GradientThemes.originalGradient
            : user.selectedTheme == 'Natural'
                ? GradientThemes.naturalGradient
                : GradientThemes.darkGradient; // Set dark theme gradient

    void logOut(WidgetRef ref) async {
      ref.read(authControllerProvider.notifier).logout();
      ref.read(selectedIndexProvider.notifier).update((state) => 0);
      ref.read(quoteProvider.notifier).update((state) => null);
      //ref.read(userProvider.notifier).update((state) => null);
    }
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',       
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Routemaster.of(context).pop();
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
            padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Account Settings',       
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Manage your account details',       
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SettingsTile(
                  color: Colors.white,
                  icon: Ionicons.person_circle_outline,
                  title: "Change Username",
                  onTap: () {
                    Routemaster.of(context).push("change_username");
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SettingsTile(
                  color: Colors.white,
                  icon: Ionicons.mail_outline,
                  title: "Change Email",
                  onTap: () {
                    Routemaster.of(context).push("change_email");
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SettingsTile(
                  color: Colors.white,
                  icon: Ionicons.lock_closed_outline,
                  title: "Change Password",
                  onTap: () {
                    Routemaster.of(context).push("change_password");
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                  thickness: 0.263,
                  color: Colors.white, // Adjust the color to fit your design
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Preferences',       
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Personalize HabitPal',       
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SettingsTile(
                  color: Colors.white,
                  icon: Ionicons.pencil_outline,
                  title: "Motivational Quotes",
                  onTap: () {
                    Routemaster.of(context).push("change_preferences");
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SettingsTile(
                  color: Colors.white,
                  icon: Ionicons.moon_outline,
                  title: "Themes",
                  onTap: () {
                    Routemaster.of(context).push("change_preferences");
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SettingsTile(
                  color: Colors.white,
                  icon: Ionicons.notifications_circle_outline,
                  title: "Set Reminders",
                  onTap: () {
                    Routemaster.of(context).push("change_preferences");
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                  thickness: 0.263,
                  color: Colors.white, // Adjust the color to fit your design
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'About Us',       
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'HabitPal Details and Contact Information',       
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SettingsTile(
                  color: Colors.white,
                  icon: Ionicons.document_text_outline,
                  title: "Release Notes",
                  onTap: () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                SettingsTile(
                  color: Colors.white,
                  icon: Ionicons.information_circle_outline,
                  title: "App Information",
                  onTap: () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                SettingsTile(
                  color: Colors.white,
                  icon: Ionicons.call_outline,
                  title: "Contact Information",
                  onTap: () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                SettingsTile(
                  color: Colors.white,
                  icon: Ionicons.star_outline,
                  title: "Rating",
                  onTap: () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                SettingsTile(
                  color: Colors.white,
                  icon: Ionicons.book_outline,
                  title: "Terms of Service",
                  onTap: () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                  thickness: 0.263,
                  color: Colors.white, // Adjust the color to fit your design
                ),
                const SizedBox(
                  height: 10,
                ),
                SettingsTile(
                  color: Colors.red,
                  icon: Ionicons.log_out_outline,
                  title: "Log Out",
                  onTap: () async {
                    logOut(ref);
                    Routemaster.of(context).popUntil((route) => route.path == '/');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
