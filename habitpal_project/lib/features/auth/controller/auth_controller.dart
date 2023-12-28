import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:habitpal_project/features/auth/repository/auth_repository.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/core/utils.dart';
import 'package:habitpal_project/model/user_model.dart';

// State provider is a way to manage and listen to state changes
// User model can be null so '?' used
// ((ref) => null) initially state is null no user is logged in
final userProvider = StateProvider<UserModel?>((ref) => null);

// State notifier provider allows to read and modify state
// <AuthController, bool> type of state managed is bool and AuthController will control this state
// creates instance of AuthController, fetches it authRepository, and reference to controll access other providers 
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

// Controller class for handling authentication logic
class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository; // Instance of AuthRepository for authentication operations
  final Ref _ref; // Reference to the Riverpod provider
  AuthController(
    {
      required AuthRepository authRepository,
      required Ref ref,
    }
  ) : _authRepository = authRepository,
      _ref = ref,
      super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  // Method to sign in with Google
  void signInWithGoogle(BuildContext context) async {
    state = true; // Set the loading state to true
    final user = await _authRepository.signInWithGoogle(); // Get User Data
    state = false; // Set the loading state to false after sign-in attempt
    user.fold(
      // If sign-in fails, show a snackbar with the error message
      (l) => showSnackBar(context, l.message), 
      // If sign-in succeeds, update the user state using Riverpod
      (userModel) => _ref.read(userProvider.notifier).update((state) => userModel),
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => const Home())));
    );
  }

  //signup with email and password
  void signUpWithEmail(BuildContext context, String email, String password, String username) async {
    state = true; // Set the loading state to true
    final user = await _authRepository.signUpWithEmail(
      email: email,
      password: password,
      username: username, // Pass the username to the signUpWithEmail method
    ); // Sign up with email and password
    state = false; // Set the loading state to false after sign-up attempt
    user.fold(
      // If sign-up fails, show a snackbar with the error message
      (l) => showSnackBar(context, l.message),
      // If sign-up succeeds, update the user state using Riverpod
      (userModel) {
       // _ref.read(userProvider.notifier).update((state) => userModel);
       // Navigator.pop(context);
      },
    );
  }

  void signInWithEmail(BuildContext context, String email, String password,) async {
    state = true;
    final user = await _authRepository.signInWithEmail(
      email: email,
      password: password,
    ); 
    state = false;
    user.fold(
      // If sign-in fails, show a snackbar with the error message
      (l) => showSnackBar(context, l.message),
      // If sign-in succeeds, update the user state using Riverpod
      (userModel) {
        _ref.read(userProvider.notifier).update((state) => userModel);
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => const Home())));
      },
    );
  }

  void forgotPassword(BuildContext context, String email,) async {
    state = true;
    final user = await _authRepository.forgotPassword(
      email: email,
    ); 
    state = false;
    user.fold(
      // If reset password fails, show a snackbar with the error message
      (l) => showSnackBar(context, l.message),
      // If reset password succeeds, update the user state using Riverpod
      (r) => null,
    );
  }

  void changeUsername(BuildContext context, String username,) async {
    state = true;
    final user = await _authRepository.changeUsername(
      username: username,
    ); 
    state = false;
    user.fold(
      // If reset password fails, show a snackbar with the error message
      (l) => showSnackBar(context, l.message),
      // If reset password succeeds, update the user state using Riverpod
      (r) => null,
    );
  }

  void changePassword(BuildContext context, String password, String newPassword) async {
    state = true;
    final user = await _authRepository.changePassword(
      password: password,
      newPassword: newPassword
    );
    state = false;
    user.fold(
      // If reset password fails, show a snackbar with the error message
      (l) => showSnackBar(context, l.message),
      // If reset password succeeds, update the user state using Riverpod
      (r) => null,
    );
  }

  void changeMotivationalQuotes(BuildContext context, List<String> selectedQuotesCategories) async {
    state = true;
    final user = await _authRepository.changeMotivationalQuotes(
      selectedQuotesCategories: selectedQuotesCategories
    );
    state = false;
    user.fold(
      // If reset password fails, show a snackbar with the error message
      (l) => showSnackBar(context, l.message),
      // If reset password succeeds, update the user state using Riverpod
      (r) => null,
    );
  }

  void changeType(BuildContext context, String selectedTheme) async {
    state = true;
    final user = await _authRepository.changeTheme(
      selectedTheme: selectedTheme
    );
    state = false;
    user.fold(
      // If reset password fails, show a snackbar with the error message
      (l) => showSnackBar(context, l.message),
      // If reset password succeeds, update the user state using Riverpod
      (r) => null,
    );
  }

  void changeEmail(BuildContext context, String password, String email) async {
    state = true;
    final user = await _authRepository.changeEmail(
      password: password,
      email: email
    );
    state = false;
    user.fold(
      // If reset password fails, show a snackbar with the error message
      (l) => showSnackBar(context, l.message),
      // If reset password succeeds, update the user state using Riverpod
      (r) => null,
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logout() async {
    _authRepository.logOut();
  }
}