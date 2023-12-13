import 'package:flutter/material.dart';
import 'package:habitpal_project/features/achievements/screens/Achievement.dart';
import 'package:habitpal_project/features/history/screens/History.dart';
import 'package:habitpal_project/features/home/screens/Home.dart';
import 'package:habitpal_project/features/settings/screens/settings.dart';
import 'package:habitpal_project/widgets/loader.dart';
import 'package:routemaster/routemaster.dart';
import 'package:habitpal_project/features/auth/screens/login.dart';
import 'package:habitpal_project/features/auth/screens/signup.dart';
import 'package:habitpal_project/features/auth/screens/forgot_password.dart';


// loggedOut
final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LogInScreen()),
  '/signup': (_) => const MaterialPage(child: SignUpScreen()),
  '/forgot_password' : (_) => const MaterialPage(child: ResetPassword()),
  '/settings' : (_) => const MaterialPage(child: Loader()),
});

// LoggedIn
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: Home()),
  '/settings': (_) => const MaterialPage(child: Settings()),
  '/history': (_) => const MaterialPage(child: History()),
  '/achievement': (_) => const MaterialPage(child: Achievement()),
});