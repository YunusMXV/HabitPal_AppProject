import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/features/achievements/screens/achievement.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:habitpal_project/features/auth/screens/forgot_password.dart';
import 'package:habitpal_project/features/auth/screens/login.dart';
import 'package:habitpal_project/features/auth/screens/signup.dart';
import 'package:habitpal_project/features/history/screens/history.dart';
import 'package:habitpal_project/features/home/controller/home_controller.dart';
import 'package:habitpal_project/features/home/screens/Home.dart';
import 'package:habitpal_project/features/settings/screens/settings.dart';
import 'package:habitpal_project/features/settings/screens/change_username.dart';
import 'package:habitpal_project/features/settings/screens/change_preferences.dart';
import 'package:habitpal_project/features/settings/screens/change_password.dart';
import 'package:habitpal_project/features/settings/screens/change_email.dart';
import 'package:habitpal_project/model/quotes_model.dart';
import 'package:habitpal_project/model/user_model.dart';
import 'MockFirebaseAuth.dart';

final mockUserData = UserModel(
      uid: "kpf2vjJud9ejks1rWZvdXOZ4AUj2",
      email: "yunus123@gmail.com",
      username: "Yunus123",
      habits: [],
      selectedQuotesCategories: [
        "Exploring",
        "Kindness",
        "Listening",
        "Giving",
        "Optimism",
        "Resilience",
        "Helping",
      ],
      selectedTheme: "Original",
      maxStreak: 0,
      currentStreak: 0,
    );

final mockQuoteData = QuotesModel(
  uid: "w57gB9X3e654V16nW28fJ0k0l2gB", 
  description: "You have to create your life. You have to carve it, like a sculpture.", 
  type: "Exploring"
);
final mockUserProvider = StateProvider<UserModel?>((ref) => mockUserData);

final mockQuoteProvider = StateProvider<QuotesModel?>((ref) => mockQuoteData);


void main() {
  setupFirebaseAuthMocks();

  // Set up Firebase mocks
  setUpAll(() async {
    await Firebase.initializeApp();
    await loadAppFonts();
  });

  testGoldens('Reset Screen', (tester) async {
    final widget = MaterialApp(
      home: ProviderScope(
        child: ResetPassword(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(500, 1000),
    );

    await screenMatchesGolden(tester, 'ResetPassword_screen');
  });

  testGoldens('LoginScreen', (tester) async {
    final widget = MaterialApp(
      home: ProviderScope(
        child: LogInScreen(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(500, 1000),
    );

    await screenMatchesGolden(tester, 'Login_screen');
  });

  testGoldens('SignUpScreen', (tester) async {
    final widget = MaterialApp(
      home: ProviderScope(
        child: SignUpScreen(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(500, 1000),
    );

    await screenMatchesGolden(tester, 'Signup_screen');
  });

  testGoldens('SettingsScreen', (tester) async {

    final widget = MaterialApp(
      home: ProviderScope(
        overrides: [userProvider.overrideWithProvider(mockUserProvider)],
        child: Settings(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(500, 1000),
    );
    await tester.pumpAndSettle(); // Wait for provider updates and animations

    await screenMatchesGolden(tester, 'Settings_screen');
  });

  testGoldens('ChangeUsernameScreen', (tester) async {

    final widget = MaterialApp(
      home: ProviderScope(
        overrides: [userProvider.overrideWithProvider(mockUserProvider)],
        child: ChangeUsername(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(500, 1000),
    );
    await tester.pumpAndSettle(); // Wait for provider updates and animations

    await screenMatchesGolden(tester, 'ChangeUsername_screen');
  });

  testGoldens('ChangePreferencesScreen', (tester) async {

    final widget = MaterialApp(
      home: ProviderScope(
        overrides: [userProvider.overrideWithProvider(mockUserProvider)],
        child: ChangePreferences(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(500, 1000),
    );
    await tester.pumpAndSettle(); // Wait for provider updates and animations

    await screenMatchesGolden(tester, 'ChangePreferences_screen');
  });

  testGoldens('ChangePasswordScreen', (tester) async {

    final widget = MaterialApp(
      home: ProviderScope(
        overrides: [userProvider.overrideWithProvider(mockUserProvider)],
        child: ChangePassword(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(500, 1000),
    );
    await tester.pumpAndSettle(); // Wait for provider updates and animations

    await screenMatchesGolden(tester, 'ChangePassword_screen');
  });

  testGoldens('ChangeEmailScreen', (tester) async {

    final widget = MaterialApp(
      home: ProviderScope(
        overrides: [userProvider.overrideWithProvider(mockUserProvider)],
        child: ChangeEmail(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(500, 1000),
    );
    await tester.pumpAndSettle(); // Wait for provider updates and animations

    await screenMatchesGolden(tester, 'ChangeEmail_screen');
  });

  testGoldens('AchievementScreen', (tester) async {

    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProviderScope(
        overrides: [userProvider.overrideWithProvider(mockUserProvider)],
        child: Achievement(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(500, 1000),
    );
    await tester.pumpAndSettle(); // Wait for provider updates and animations

    await screenMatchesGolden(tester, 'Achievement_screen');
  });

  testGoldens('HomeScreen', (tester) async {

    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProviderScope(
        overrides: [
          userProvider.overrideWithProvider(mockUserProvider),
          quoteProvider.overrideWithProvider(mockQuoteProvider)
        ],
        child: Home(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(500, 1000),
    );
    await tester.pumpAndSettle(const Duration(seconds: 100));

    await screenMatchesGolden(tester, 'Home_screen');
  });

  testGoldens('HistoryScreen', (tester) async {

    final widget = MaterialApp(
      home: ProviderScope(
        overrides: [userProvider.overrideWithProvider(mockUserProvider)],
        child: History(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(500, 1000),
    );
    await tester.pumpAndSettle(); // Wait for provider updates and animations

    await screenMatchesGolden(tester, 'History_screen');
  });
}