import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:habitpal_project/Screens/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadImages(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          FlutterNativeSplash.remove();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: '',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
              useMaterial3: true,
            ),
            home: const LogInScreen(),
          );
        } else {
          return const MaterialApp(
          );
        }
      },
    );
  }

  Future<void> _loadImages(BuildContext context) async {
    await precacheImage(const AssetImage('assets/images/Login.png'), context);
    // ignore: use_build_context_synchronously
    await precacheImage(const AssetImage('assets/images/Signup.png'), context);
    // ignore: use_build_context_synchronously
    await precacheImage(const AssetImage('assets/images/google.png'), context);
  }
}