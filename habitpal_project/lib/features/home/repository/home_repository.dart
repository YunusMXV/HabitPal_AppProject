import 'dart:math';

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

  Future<Either<Failure, Habit>> createHabit({
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
        DocumentReference userDocRef =
            _firestore.collection('users').doc(user.uid);

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
          progressHistory: [],
          completionDeadline: completionDeadline,
        );

        // Convert the Habit model to a Map
        Map<String, dynamic> habitMap = habitModel.toMap();

        // Add the habit to the user's habit list
        List<Map<String, dynamic>> updatedHabits = [
          ...userModel.habits.map((habit) => habit.toMap()), // Convert existing habits to Map
          habitMap, // Add the new habit Map
        ];

        // Update the user model in Firestore
        await _firestore.collection('users').doc(user.uid).update({
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

  Future<Either<Failure, Habit>> editHabit({
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