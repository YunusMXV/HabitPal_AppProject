import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:habitpal_project/features/auth/screens/login.dart';
import 'package:habitpal_project/router.dart';
import 'package:habitpal_project/widgets/settings_tile.dart';
import 'package:ionicons/ionicons.dart';
import 'package:habitpal_project/utils/color_utils.dart';
import 'package:routemaster/routemaster.dart';
import 'package:habitpal_project/features/settings/screens/change_password.dart';
import 'package:habitpal_project/features/settings/screens/change_email.dart';
import 'package:habitpal_project/features/settings/screens/change_username.dart';

//import 'package:habitpal_project/Screens/Home.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();

}

class _SettingsState extends ConsumerState<Settings> {
  @override
  Widget build(BuildContext context) {

    void logOut(WidgetRef ref) async {
      ref.read(authControllerProvider.notifier).logout();

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
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
          hexToColor("315b7d"), // #B4E1C5 to #ABCEAF to #B0DDD9
          hexToColor("1d4769"), // #315b7d to #1d4769 to #223F57
          hexToColor("223F57")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangeUsername(),
                      ),
                    );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangeEmail(),
                      ),
                    );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePassword(),
                      ),
                    );
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
                  onTap: () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                SettingsTile(
                  color: Colors.white,
                  icon: Ionicons.moon_outline,
                  title: "Themes",
                  onTap: () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                SettingsTile(
                  color: Colors.white,
                  icon: Ionicons.notifications_circle_outline,
                  title: "Set Reminders",
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
                    Routemaster.of(context).replace('/');
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
