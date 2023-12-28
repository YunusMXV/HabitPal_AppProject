import 'dart:math';
import 'package:intl/intl.dart'; // Import for DateFormat
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:habitpal_project/core/providers/firebase_providers.dart';
import 'package:habitpal_project/model/habit_model.dart';
import 'package:habitpal_project/model/progress_history_model.dart';
import 'package:habitpal_project/model/quotes_model.dart';
import 'package:habitpal_project/model/user_model.dart';
import 'package:habitpal_project/core/constants/firebase_constants.dart';
import 'package:habitpal_project/core/type_defs.dart';
import 'package:habitpal_project/core/failure.dart';

// Provider for the authentication repository
final homeRepositoryProvider = Provider((ref) => HomeRepository(
    firestore: ref.read(firestoreProvider), 
    auth: ref.read(authProvider), 
  ),
);


// Class representing the authentication repository
class HomeRepository {
  final FirebaseFirestore _firestore; // Firestore instance
  final FirebaseAuth _auth; // Firebase Authentication instance

  // Constructor to initialize the repository with necessary instances
  HomeRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
      _firestore = firestore;
  // Reference to the users collection in Firestore
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _quotes => _firestore.collection(FirebaseConstants.motivationalquotesCollection);
  CollectionReference get _habits => _firestore.collection(FirebaseConstants.habitCollection);



  FutureEither<QuotesModel> getRandomMotivationalQuote({
    required List<String> selectedCategories,
  }) async {
    try {

      // Retrieve user data from Firestore
      List<QuotesModel> quotes = await getQuotes(); // Await the Future to get the list of quotes

      List<QuotesModel> filteredQuotes = quotes
      .where((quote) => selectedCategories.contains(quote.type))
      .toList();

      if (filteredQuotes.isNotEmpty) {
        // Select a random quote from the filtered list
        final randomIndex = Random().nextInt(filteredQuotes.length);
        final randomQuote = filteredQuotes[randomIndex];
        return right(randomQuote); // Return the random quote on success
      } else {
        throw Exception('No motivational quotes found in the selected categories.');
      }// Return the user model on success
    } on FirebaseException catch (e) {
      throw e.message!; // Throw an exception with Firebase error message
    } catch (e) {
      return left(Failure(e.toString())); // Return a failure on other exceptions
    }
  }

  FutureEither<Habit> createHabit({
    required String habitTitle,
    required String description,
    required String category,
    required Set<String> targetCompletionDays,
    required DateTime completionDeadline,
  }) async {
    try {
      // Retrieve the current user model
      User? user = _auth.currentUser;

      if (user != null) {
        // Retrieve the current user's document reference
        DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);

        // Check for duplicate habit titles in the Habit list of the current user
        DocumentSnapshot userSnapshot = await userDocRef.get();
        UserModel userModel = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);

        if (userModel.habits.any((habit) => habit.habitTitle == habitTitle)) {
          return left(Failure('Habit with this title already exists.'));
        }

        // Create the habit model
        Habit habitModel = Habit(
          habitId: _habits.doc().id,
          habitTitle: habitTitle,
          description: description,
          category: category,
          targetCompletionDays: targetCompletionDays,
          progressHistory: [], // Initialize with an empty list
          completionDeadline: completionDeadline,
        );

        // Add progress entries for the next occurrences of the habit
        _addProgressEntriesForNextOccurrences(habitModel);

        // Convert the Habit model to a Map
        Map<String, dynamic> habitMap = habitModel.toMap();

        // Add the habit to the user's habit list
        List<Map<String, dynamic>> updatedHabits = [
          ...userModel.habits.map((habit) => habit.toMap()), // Convert existing habits to Map
          habitMap, // Add the new habit Map
        ];

        // Update the user model in Firestore
        await userDocRef.update({
          'habits': updatedHabits,
        });

        return right(habitModel); // Return the created habit on success
      } else {
        return left(Failure('User not authenticated.'));
      }
    } on FirebaseException catch (e) {
      return left(Failure(e.message!)); // Throw an exception with Firebase error message for other cases
    } catch (e) {
      return left(Failure(e.toString())); // Return a failure on other exceptions
    }
  }
  void _addProgressEntriesForNextOccurrences(Habit habitModel) {
    DateTime? currentDate = DateTime.now();
    DateTime completionDeadline = habitModel.completionDeadline;
    Set<String> targetCompletionDays = habitModel.targetCompletionDays;

    do {
      // Convert the weekday to a string representation
      String currentDayString = _getDayString(currentDate!.weekday);

      // Check if the current day is one of the target completion days
      if (targetCompletionDays.contains(currentDayString)) {
        // Create a ProgressEntry for the current date with completed = false
        ProgressEntry progressEntry = ProgressEntry(
          date: DateTime(currentDate.year, currentDate.month, currentDate.day),
          completed: false,
        );
        // Ensure that the progressEntry is being added to the habitModel's progressHistory
        habitModel.progressHistory.add(progressEntry);
      }

      // Move to the next occurrence of the target completion day
      currentDate = _getNextTargetCompletionDate(currentDate, targetCompletionDays, completionDeadline);
    } while (currentDate != null && currentDate.isBefore(completionDeadline));

    print("Finish date: $currentDate");
    print(habitModel);
  }

  String _getDayString(int weekday) {
    // Convert weekday (1 to 7) to a string representation
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "";
    }
  }


  DateTime? _getNextTargetCompletionDate(
    DateTime currentDate, Set<String> targetCompletionDays, DateTime completionDeadline) {
    // Find the next target completion day from the current date, considering completionDeadline
    print("\nCurrent Date: $currentDate");
    for (int i = 1; i <= 7; i++) {
      DateTime nextDate = currentDate.add(Duration(days: i));
      print("Next Date: $nextDate");
      // Check if nextDate is beyond completionDeadline and break if so
      print(nextDate.isAfter(completionDeadline));
      if (nextDate.isAfter(completionDeadline)) {
        break;
      }

      String currentDayString = _getDayString(nextDate.weekday);

      if (targetCompletionDays.contains(currentDayString)) {
        return nextDate;
      }
    }
    return null;
  }


  FutureEither<Unit> editProgress({
    required String habitId,
    required DateTime date,
    required bool completed,
  }) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);

        // Get the user model
        DocumentSnapshot userSnapshot = await userDocRef.get();
        UserModel userModel = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);

        // Find the index of the habit to edit
        int habitIndex = userModel.habits.indexWhere((habit) => habit.habitId == habitId);

        if (habitIndex == -1) {
          return left(Failure('Habit not found.'));
        }
        
        int progressIndex = userModel.habits[habitIndex].progressHistory.indexWhere(
          (progress) =>
              progress.date.year == date.year &&
              progress.date.month == date.month &&
              progress.date.day == date.day,
        );

        if (progressIndex == -1) {
          return left(Failure('Progress entry not found.'));
        }

        // Create the updated progress entry
        ProgressEntry updatedProgressEntry = ProgressEntry(
          date: userModel.habits[habitIndex].progressHistory[progressIndex].date,
          completed: completed,
        );

        // Update the progressHistory list in the user model
        List<ProgressEntry> updatedProgressHistory = [
          ...userModel.habits[habitIndex].progressHistory.sublist(0, progressIndex),
          updatedProgressEntry,
          ...userModel.habits[habitIndex].progressHistory.sublist(progressIndex + 1),
        ];

        // Update the user model in Firestore
        await userDocRef.update({
          'habits': [
            ...userModel.habits.sublist(0, habitIndex),
            Habit(
              habitId: userModel.habits[habitIndex].habitId,
              habitTitle: userModel.habits[habitIndex].habitTitle,
              description: userModel.habits[habitIndex].description,
              category: userModel.habits[habitIndex].category,
              targetCompletionDays: userModel.habits[habitIndex].targetCompletionDays,
              progressHistory: updatedProgressHistory,
              completionDeadline: userModel.habits[habitIndex].completionDeadline,
            ),
            ...userModel.habits.sublist(habitIndex + 1),
          ].map((habit) => habit.toMap()).toList(),
        });

        return right(unit); // Return success
      } else {
        return left(Failure('User not authenticated.'));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }


  FutureEither<ProgressEntry?> getProgressEntryForDate({
    required String habitId,
    required DateTime currentDate,
  }) async {
    try {
      DocumentReference userDocRef = _firestore.collection('users').doc(_auth.currentUser!.uid);

      // Get the user model
      DocumentSnapshot userSnapshot = await userDocRef.get();
      UserModel userModel = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);

      // Find the habit by habitId
      Habit? habit = userModel.habits.firstWhere((habit) => habit.habitId == habitId);

      // Find the progress entry for the current date
      ProgressEntry? progressEntry = habit.progressHistory.firstWhere(
        (progress) => DateFormat('yyyy-MM-dd').format(progress.date) ==
            DateFormat('yyyy-MM-dd').format(currentDate),
      );
      return right(progressEntry);
    } catch (e) {
      throw Failure(e.toString());
    }
  }




  FutureEither<Habit> editHabit({
    required String habitId,
    required String habitTitle,
    required String description,
    required String category,
    required Set<String> targetCompletionDays,
    required DateTime completionDeadline,
  }) async {
    try {
      // Retrieve the current user model
      User? user = _auth.currentUser;

      if (user != null) {
        // Retrieve the current user's document reference
        DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);

        // Fetch the user document
        DocumentSnapshot userSnapshot = await userDocRef.get();
        UserModel userModel = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);

        // Find the index of the habit to edit
        int habitIndex = userModel.habits.indexWhere((habit) => habit.habitId == habitId);

        if (habitIndex == -1) {
          return left(Failure('Habit not found.'));
        }

        // Create the updated habit model
        Habit updatedHabit = Habit(
          habitId: habitId, // Preserve the existing habit ID
          habitTitle: habitTitle,
          description: description,
          category: category,
          targetCompletionDays: targetCompletionDays,
          progressHistory: userModel.habits[habitIndex].progressHistory, // Preserve progress history
          completionDeadline: completionDeadline,
        );

        // Update the habits list in the user model
        List<Habit> updatedHabits = [
          ...userModel.habits.sublist(0, habitIndex),
          updatedHabit,
          ...userModel.habits.sublist(habitIndex + 1),
        ];

        // Update the user document in Firestore
        await userDocRef.update({'habits': updatedHabits.map((habit) => habit.toMap()).toList()});

        return right(updatedHabit); // Return the updated habit on success
      } else {
        return left(Failure('User not authenticated.'));
      }
    } on FirebaseException catch (e) {
      return left(Failure(e.message!)); // Return a failure with Firebase error message
    } catch (e) {
      return left(Failure(e.toString())); // Return a failure with general error message
    }
  }

  FutureVoid deleteHabit({
    required String habitId,
  }) async {
    try {
      // Retrieve the current user model
      User? user = _auth.currentUser;

      if (user != null) {
        // Retrieve the current user's document reference
        DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);

        // Fetch the user document
        DocumentSnapshot userSnapshot = await userDocRef.get();
        UserModel userModel = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);

        // Find the index of the habit to delete
        int deleteIndex = userModel.habits.indexWhere((habit) => habit.habitId == habitId);

        if (deleteIndex == -1) {
          return left(Failure('Habit not found.'));
        }

        // Remove the habit from the habits list
        List<Habit> deletedHabits = List.from(userModel.habits)..removeAt(deleteIndex);

        // Update the user document in Firestore
        await userDocRef.update({'habits': deletedHabits.map((habit) => habit.toMap()).toList()});

        return right(null); // Return true indicating successful deletion
      } else {
        return left(Failure('User not authenticated.'));
      }
    } on FirebaseException catch (e) {
      return left(Failure(e.message!)); // Return a failure with Firebase error message
    } catch (e) {
      return left(Failure(e.toString())); // Return a failure with general error message
    }
  }

  FutureEither<List<double>> calculateWeeklyProgress({
    required List<Habit> habits,
  }) async {
    try {
      // Retrieve the current user model
      User? user = _auth.currentUser;

      if (user != null) {
        // Retrieve the current user's document reference
        DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);

        // Fetch the user document
        DocumentSnapshot userSnapshot = await userDocRef.get();
        UserModel userModel = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);

        DateTime currentDate = DateTime.now();

        int currentDay = currentDate.weekday;

        //String currentWeekday = _getDayString(currentDay);

        List<double> weeklyProgress = List.generate(7, (index) => 0.0);

        int loop = currentDay == 7 ? 1 : 1 + currentDay;

        // s 1 m 2 t 3 w 4 t 5 f 6 s 7
        for (int i = loop; i > 0; i--) {
          int numerator = 0;
          int denominator = 0;

          for(Habit habit in userModel.habits)
          {
            // Check if there is a progress entry for the current date
            ProgressEntry? progressEntry;
            try {
              progressEntry = habit.progressHistory.firstWhere(
                (entry) => entry.date.year == currentDate.year &&
                    entry.date.month == currentDate.month &&
                    entry.date.day == currentDate.day,
              );
              if(progressEntry.completed) {
                numerator += 1;
                denominator += 1;
              }
              else {
                denominator += 1;
              }
            } catch (e) {
              print("Something Wrong");
            }
          }
          if(denominator != 0){
            weeklyProgress[i-1] = ((numerator/denominator)*100);
          }
          currentDate = currentDate.subtract(const Duration(days: 1));
        }
        return right(weeklyProgress);
      } else {
        return left(Failure('User not authenticated.'));
      }
    } on FirebaseException catch (e) {
      return left(Failure(e.message!)); // Return a failure with Firebase error message
    } catch (e) {
      return left(Failure(e.toString())); // Return a failure with general error message
    }
  }

  FutureEither<List<double>> calculateWeeklyTypes({
    required List<Habit> habits,
  }) async {
    try {
      // Retrieve the current user model
      User? user = _auth.currentUser;

      if (user != null) {
        // Retrieve the current user's document reference
        DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);

        // Fetch the user document
        DocumentSnapshot userSnapshot = await userDocRef.get();
        UserModel userModel = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);

        // DateTime currentDate = DateTime.now();

        // int currentDay = currentDate.weekday;

        //String currentWeekday = _getDayString(currentDay);

        List<int> categoryProgress = List.generate(9, (index) => 0);

        for(Habit habit in userModel.habits)
        {
          switch (habit.category) {
            case "Physical":
              categoryProgress[0] = categoryProgress[0] + 1;
              break;
            case "Mental":
              categoryProgress[1] = categoryProgress[1] + 1;
              break;
            case "Productivity":
              categoryProgress[2] = categoryProgress[2] + 1;
              break;
            case "Social":
              categoryProgress[3] = categoryProgress[3] + 1;
              break;
            case "Creativity":
              categoryProgress[4] = categoryProgress[4] + 1;
              break;
            case "Financial":
              categoryProgress[5] = categoryProgress[5] + 1;
              break;
            case "Spiritual":
              categoryProgress[6] = categoryProgress[6] + 1;
              break;
            case "Passion":
              categoryProgress[7] = categoryProgress[7] + 1;
              break;
            case "Personal":
              categoryProgress[8] = categoryProgress[8] + 1;
              break;
            default:
          }
        }

      List<double> resultList = divideListByNumber(categoryProgress, userModel.habits.length.toDouble());

        return right(resultList);
      } else {
        return left(Failure('User not authenticated.'));
      }
    } on FirebaseException catch (e) {
      return left(Failure(e.message!)); // Return a failure with Firebase error message
    } catch (e) {
      return left(Failure(e.toString())); // Return a failure with general error message
    }
  }

  List<double> divideListByNumber(List<int> originalList, double divisor) {
    return originalList.map((int number) => number / divisor).toList();
  }



  // Method to get user data from Firestore using the user ID
  // Stream means a continuous changing flow of that specific uid 
  Stream<UserModel> getUserData(String uid) {
    //taking raw data of user of this uid and mapping it according to the model
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  Future<List<QuotesModel>> getQuotes() async {
    try {
      QuerySnapshot snapshot = await _quotes.get();
      List<QuotesModel> quotesList = snapshot.docs
          .map((doc) {
            print('Raw Data: ${doc.data()}');
            return QuotesModel.fromMap(doc.data() as Map<String, dynamic>);
          })
          .toList();

      // Print the quotes to the console for debugging
      print('Fetched ${quotesList.length} quotes:');
      for (var quote in quotesList) {
        print('Quote: $quote');
      }

      return quotesList;
    } catch (e) {
      print('Error fetching quotes: $e');
      // Handle the error, return an empty list or throw an exception
      return [];
    }
  }
}