import 'package:flutter/material.dart';
import 'package:habitpal_project/features/achievements/screens/achievement.dart';
import 'package:habitpal_project/features/history/screens/history.dart';
import 'package:habitpal_project/features/home/screens/Home.dart';
import 'package:habitpal_project/features/settings/screens/settings.dart';
import 'package:habitpal_project/widgets/loader.dart';
import 'package:routemaster/routemaster.dart';
import 'package:habitpal_project/features/auth/screens/login.dart';
import 'package:habitpal_project/features/auth/screens/signup.dart';
import 'package:habitpal_project/features/auth/screens/forgot_password.dart';
import 'package:habitpal_project/features/settings/screens/change_email.dart';
import 'package:habitpal_project/features/settings/screens/change_username.dart';
import 'package:habitpal_project/features/settings/screens/change_password.dart';
import 'package:habitpal_project/features/settings/screens/change_preferences.dart';


// loggedOut
final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LogInScreen()),
  '/signup': (_) => const MaterialPage(child: SignUpScreen()),
  '/forgot_password' : (_) => const MaterialPage(child: ResetPassword()),
  //'/settings' : (_) => const MaterialPage(child: Loader()),
});

// LoggedIn
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: Home()),
  '/settings': (_) => const MaterialPage(child: Settings()),
  '/achievement/settings': (_) => const MaterialPage(child: Settings()),
  '/history/settings': (_) => const MaterialPage(child: Settings()),
  '/history': (_) => const MaterialPage(child: History()),
  '/achievement': (_) => const MaterialPage(child: Achievement()),
  '/settings/change_username': (_) => const MaterialPage(child: ChangeUsername()),
  '/settings/change_password': (_) => const MaterialPage(child: ChangePassword()),
  '/settings/change_email': (_) => const MaterialPage(child: ChangeEmail()),
  '/settings/change_preferences': (_) => const MaterialPage(child: ChangePreferences()),
  '/achievement/settings/change_username': (_) => const MaterialPage(child: ChangeUsername()),
  '/achievement/settings/change_password': (_) => const MaterialPage(child: ChangePassword()),
  '/achievement/settings/change_email': (_) => const MaterialPage(child: ChangeEmail()),
  '/achievement/settings/change_preferences': (_) => const MaterialPage(child: ChangePreferences()),
  '/history/settings/change_username': (_) => const MaterialPage(child: ChangeUsername()),
  '/history/settings/change_password': (_) => const MaterialPage(child: ChangePassword()),
  '/history/settings/change_email': (_) => const MaterialPage(child: ChangeEmail()),
  '/history/settings/change_preferences': (_) => const MaterialPage(child: ChangePreferences()),
});
