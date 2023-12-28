import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habitpal_project/core/providers/firebase_providers.dart';
import 'package:habitpal_project/model/user_model.dart';
import 'package:habitpal_project/core/constants/firebase_constants.dart';
import 'package:habitpal_project/core/type_defs.dart';
import 'package:habitpal_project/core/failure.dart';

// Provider for the authentication repository
final authRepositoryProvider = Provider((ref) => AuthRepository(
  firestore: ref.read(firestoreProvider), 
  auth: ref.read(authProvider), 
  googleSignIn: ref.read(googleSignInProvider)
  ),
);


// Class representing the authentication repository
class AuthRepository {
  final FirebaseFirestore _firestore; // Firestore instance
  final FirebaseAuth _auth; // Firebase Authentication instance
  final GoogleSignIn _googleSignIn; // Google Sign-In instance

  // Constructor to initialize the repository with necessary instances
  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  }) : _auth = auth,
       _firestore = firestore,
       _googleSignIn = googleSignIn;

  // Reference to the users collection in Firestore
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  // Method for signing in with Google
  FutureEither<UserModel> signInWithGoogle() async {
    try {
      //opens google sign in screen
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      //retrieve authentication details of that user
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, //represents authorization granted to individual
        idToken: googleAuth?.idToken, //web token of the user
      );

      //signing in user with the credential
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      UserModel userModel;
      
      if(userCredential.additionalUserInfo!.isNewUser)
      {
        // Create a new user model and add it to Firestore if the user is new
        userModel = UserModel(
          uid: userCredential.user!.uid, 
          email: userCredential.user!.email!, 
          username: userCredential.user!.displayName??"John Doe", 
          habits: [], 
          selectedQuotesCategories: ["Exploring", "Kindness", "Listening", "Giving", "Optimism", "Resilience", "Helping"],
          selectedTheme: "Original",
          maxStreak: 0,
          currentStreak: 0,
        );
        // Map new user
        _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        // Retrieve the user model if the user already exists
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel); // Return the user model on success
    } on FirebaseException catch (e) {
      throw e.message!; // Throw an exception with Firebase error message
    } catch (e) {
      return left(Failure(e.toString())); // Return a failure on other exceptions
    }
  }

  //sign up with email
  FutureEither<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Attempt to create a new user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel userModel;
      // Create a user model
      userModel = UserModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
        username: username,
        habits: [],
        selectedQuotesCategories: ["Exploring", "Kindness", "Listening", "Giving", "Optimism", "Resilience", "Helping"],
        selectedTheme: "Original",
        maxStreak: 0,
        currentStreak: 0,
      );
      // Add the user model to Firestore
      _users.doc(userCredential.user!.uid).set(userModel.toMap());
      return right(userModel); // Return the user model on success
    } on FirebaseException catch (e) {
      if (e.code == 'email-already-in-use') {
        // If the email is already in use, return a failure with a custom message
        return left(Failure("The email address is already in use. Please use a different email."));
      }
      throw e.message!; // Throw an exception with Firebase error message for other cases
    } catch (e) {
      return left(Failure(e.toString())); // Return a failure on other exceptions
    }
  }

  // sign in with email password
  FutureEither<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Attempt to sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve user data from Firestore
      UserModel userModel = await getUserData(userCredential.user!.uid).first;

      return right(userModel); // Return the user model on success
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        // If the user is not found or the password is wrong, return a failure with a custom message
        return left(Failure("User not found. Please try again."));
      }
      else if (e.code == 'wrong-password') {
        return left(Failure("Invalid email or password. Please try again."));
      }
      else{
        print('Unhandled Firebase Exception: ${e.code} - ${e.message}');
        throw e.message!; // Throw an exception with Firebase error message for other cases
      }
    } catch (e) {
      return left(Failure(e.toString())); // Return a failure on other exceptions
    }
  }

  // forgot password
  FutureVoid forgotPassword({
    required String email,
  }) async {
    try {
      // Attempt to sign in with email and password
      await _auth.sendPasswordResetEmail(
        email: email,
      );
    return right(null);
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found' ){
        // If the user is not found or the password is wrong, return a failure with a custom message
        return left(Failure("Invalid email. Please try again."));
      }
      throw e.message!; // Throw an exception with Firebase error message for other cases
    } catch (e) {
      return left(Failure(e.toString())); // Return a failure on other exceptions
    }
  }

  //change username
  FutureVoid changeUsername({
    required String username,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'username': username,
        });
      }

      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!; // Throw an exception with Firebase error message for other cases
    } catch (e) {
      return left(Failure(e.toString())); // Return a failure on other exceptions
    }
  }

  //change motivational quote types
  FutureVoid changeMotivationalQuotes({
    required List<String> selectedQuotesCategories,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'selectedQuotesCategories': selectedQuotesCategories,
        });
      }

      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!; // Throw an exception with Firebase error message for other cases
    } catch (e) {
      return left(Failure(e.toString())); // Return a failure on other exceptions
    }
  }

  //change theme type
  FutureVoid changeTheme({
    required String selectedTheme,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'selectedTheme': selectedTheme,
        });
      }

      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!; // Throw an exception with Firebase error message for other cases
    } catch (e) {
      return left(Failure(e.toString())); // Return a failure on other exceptions
    }
  }

  // change password
  FutureVoid changePassword({
    required String password,
    required String newPassword,
  }) async {
    try {
      User? user = _auth.currentUser;

      // Check if the user is signed in with email and password
      bool isEmailAndPasswordSignIn = user?.providerData.any(
            (userInfo) => userInfo.providerId == EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD,
          ) ??
          false;

      if (user != null && isEmailAndPasswordSignIn) {
        // Reauthenticate the user with the current password before changing it
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);

        // If reauthentication is successful, change the password
        await user.updatePassword(newPassword);
      } else {
        return left(Failure("You are not signed in with email and password."));
      }

      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!; // Throw an exception with Firebase error message for other cases
    } catch (e) {
      return left(Failure(e.toString())); // Return a failure on other exceptions
    }
  }

  //change email
  FutureVoid changeEmail({
    required String password,
    required String email,
  }) async {
    try {
      User? user = _auth.currentUser;

      // Check if the user is signed in with email and password
      bool isEmailAndPasswordSignIn = user?.providerData.any(
            (userInfo) => userInfo.providerId == EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD,
          ) ??
          false;

      if (user != null && isEmailAndPasswordSignIn) {
        // Reauthenticate the user with the current password before changing it
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);

        // If reauthentication is successful, change the password
        List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
        if (signInMethods.isEmpty) {
          // If the email is not in use, update the email for the current user
          await user.updateEmail(email);
          // Check if the new email is verified
          if (user.emailVerified) {
            print("Email updated successfully");
          } else {
            return left(Failure("Error: Email is not verified"));
          }
        } else {
          return left(Failure("Error: Email is already in use by another account"));
        }
      } else {
        return left(Failure("You are not signed in with email and password."));
      }
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!; // Throw an exception with Firebase error message for other cases
    } catch (e) {
      return left(Failure(e.toString())); // Return a failure on other exceptions
    }
  }
  // Method to get user data from Firestore using the user ID
  // Stream means a continuous changing flow of that specific uid 
  Stream<UserModel> getUserData(String uid) {
    //taking raw data of user of this uid and mapping it according to the model
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}