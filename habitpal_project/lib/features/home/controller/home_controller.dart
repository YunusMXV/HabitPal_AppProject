import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/core/utils.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:habitpal_project/features/home/repository/home_repository.dart';
import 'package:habitpal_project/model/habit_model.dart';
import 'package:habitpal_project/model/progress_history_model.dart';
import 'package:habitpal_project/model/quotes_model.dart';
import 'package:habitpal_project/model/user_model.dart';


final selectedIndexProvider = StateProvider<int>((ref) => 0);
final quoteProvider = StateProvider<QuotesModel?>((ref) => null); // Initially null


final habitProvider = StateProvider<Habit?>((ref) => null);

// State notifier provider allows to read and modify state
// <AuthController, bool> type of state managed is bool and AuthController will control this state
// creates instance of AuthController, fetches it authRepository, and reference to controll access other providers 
final homeControllerProvider = StateNotifierProvider<HomeController, bool>(
  (ref) => HomeController(
    homeRepository: ref.watch(homeRepositoryProvider),
    ref: ref,
  ),
);

// Controller class for handling authentication logic
class HomeController extends StateNotifier<bool> {
  final HomeRepository _homeRepository; // Instance of AuthRepository for authentication operations
  final Ref _ref; // Reference to the Riverpod provider
  HomeController(
    {
      required HomeRepository homeRepository,
      required Ref ref,
    }
  ) : _homeRepository = homeRepository,
      _ref = ref,
      super(false);

  
  void getRandomMotivationalQuote(BuildContext context, List<String> selectedQuotesCategories) async {
    state = true;
    final user = await _homeRepository.getRandomMotivationalQuote(
      selectedCategories: selectedQuotesCategories,
    );
    state = false;
    user.fold(
      // If reset password fails, show a snackbar with the error message
      (l) => showSnackBar(context, l.message),
      // If reset password succeeds, update the user state using Riverpod
      (quotesModel) => _ref.read(quoteProvider.notifier).update((state) => quotesModel),
    );
  }

  void createHabit(BuildContext context, String habitTitle, String description, String category, Set<String> targetCompletionDays, DateTime completionDeadline,) async {
    state = true;
    final user = await _homeRepository.createHabit(
      habitTitle: habitTitle, 
      description: description, 
      category: category, 
      targetCompletionDays: targetCompletionDays, 
      completionDeadline: completionDeadline
    );
    state = false;
    user.fold(
      // If reset password fails, show a snackbar with the error message
      (l) => showSnackBar(context, l.message),
      // If reset password succeeds, update the user state using Riverpod
      (r) => null,
    );
  }

  void editHabit(BuildContext context, String id, String habitTitle, String description, String category, Set<String> targetCompletionDays, DateTime completionDeadline,) async {
    state = true;

    final user = await _homeRepository.editHabit(
      habitId: id,
      habitTitle: habitTitle, 
      description: description, 
      category: category, 
      targetCompletionDays: targetCompletionDays, 
      completionDeadline: completionDeadline
    );
    state = false;
    user.fold(
      // If reset password fails, show a snackbar with the error message
      (l) => showSnackBar(context, l.message),
      // If reset password succeeds, update the user state using Riverpod
      (r) => null,
    );
  }

  void deleteHabit(BuildContext context, String id) async {
    state = true;

    final user = await _homeRepository.deleteHabit(
      habitId : id,
    );
    state = false;
    user.fold(
      // If reset password fails, show a snackbar with the error message
      (l) => showSnackBar(context, l.message),
      // If reset password succeeds, update the user state using Riverpod
      (r) => null,
    );
  }
}
