import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:habitpal_project/features/auth/screens/login.dart';
import 'package:habitpal_project/model/user_model.dart';
import 'package:habitpal_project/router.dart';
import 'package:habitpal_project/widgets/loader.dart';
import 'firebase_options.dart';
import 'package:routemaster/routemaster.dart';
import 'package:habitpal_project/widgets/error_test.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp(),));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
      data: (data) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: '',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
          useMaterial3: true,
        ),
        routerDelegate: RoutemasterDelegate(
          routesBuilder: (context) {
            if (data != null) {
              getData(ref, data);
              //print("...............................B: $userModel");
              if (userModel != null) {
                //print("...............................C:");
                //print("...............................C: $userModel");
                return loggedInRoute;
              }
            }
            else {
              userModel = null;
            }
            //print("...............................A: $userModel");
            _loadImages(context).then((_) {
              FlutterNativeSplash.remove();
            });
            return loggedOutRoute;
          },
        ),
        routeInformationParser: const RoutemasterParser(),          
      ), 
      error: (error, stackTrace) => ErrorTest(error: error.toString()),
      loading: () {
        print("loading...............................");
        return const Loader();
      }
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