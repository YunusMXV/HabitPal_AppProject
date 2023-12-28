
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:habitpal_project/core/constants/firebase_constants.dart';
// import 'package:habitpal_project/core/providers/firebase_providers.dart';
// import 'package:habitpal_project/model/user_model.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// // Import your classes and functions
// import 'package:habitpal_project/features/auth/repository/auth_repository.dart';
// import 'package:habitpal_project/features/auth/controller/auth_controller.dart';

// class MockFirestore extends Mock implements FirebaseFirestore {}

// class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// class MockGoogleSignIn extends Mock implements GoogleSignIn {}

// class MockUserModel extends Mock implements UserModel {}

// // Wrapper class for CollectionReference
// class MockCollectionReferenceWrapper {
//   final CollectionReference<Map<String, dynamic>> _collectionReference;

//   MockCollectionReferenceWrapper(this._collectionReference);

//   // You can expose methods or properties you need
//   Future<DocumentReference<Map<String, dynamic>>> add(Map<String, dynamic> data) =>
//       _collectionReference.add(data);
//   Query<Map<String, dynamic>> where(
//           String field, Query op, dynamic value) =>
//       _collectionReference.where(field);
//   // Add other methods or properties you need...
// }

// // Mock class using composition with the wrapper
// class MockCollectionReference
//     extends Mock implements CollectionReference {}

// class MockDocumentReference extends Mock implements DocumentReference {}

// class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}


// @GenerateMocks([FirebaseFirestore, FirebaseAuth])
// void main() {
//   late MockFirestore mockFirestore;
//   late MockFirebaseAuth mockAuth;
//   late AuthRepository authRepository;
//   late MockDocumentSnapshot mockDocumentSnapshot;
//   late MockCollectionReference mockCollectionReference;
//   late MockDocumentReference mockDocumentReference;

//   setUp(() {
//     mockCollectionReference = MockCollectionReference();
//     mockDocumentReference = MockDocumentReference();
//     mockDocumentSnapshot = MockDocumentSnapshot();
//     mockFirestore = MockFirestore();
//     mockAuth = MockFirebaseAuth();
//     authRepository = AuthRepository(
//       firestore: mockFirestore,
//       auth: mockAuth,
//       googleSignIn: MockGoogleSignIn(), // You can mock GoogleSignIn if needed
//     );
//   });

//   test('getUserData should return a Stream of UserModel', () async {
//     // Create a mock UserModel
//     final mockUserModel = UserModel(
//       uid: "kpf2vjJud9ejks1rWZvdXOZ4AUj2",
//       email: "yunus123@gmail.com",
//       username: "Yunus123",
//       habits: [],
//       selectedQuotesCategories: [
//         "Exploring",
//         "Kindness",
//         "Listening",
//         "Giving",
//         "Optimism",
//         "Resilience",
//         "Helping",
//       ],
//       selectedTheme: "Original",
//     );

//     when(mockFirestore.collection('users')).thenReturn(mockCollectionReference as CollectionReference<Map<String, dynamic>>);
//       when(mockCollectionReference.doc('users')).thenReturn(mockDocumentReference);
//         when(mockDocumentReference.get()).thenAnswer((_) async => mockDocumentSnapshot);
//           when(mockDocumentSnapshot.data()).thenReturn(responseMap);
//           //act
//           final result = await remoteDataSource.getData(mockUserModel.uid);
//           //assert
//           expect(result, userModel);
//   });
// }