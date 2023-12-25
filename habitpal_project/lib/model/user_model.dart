

import 'package:flutter/foundation.dart';

import 'package:habitpal_project/model/habit_model.dart';

class UserModel {
  final String uid;
  final String email;
  final String username; // You may want to include this for personalization
  final List<Habit> habits;
  final List<String> selectedQuotesCategories;
  final String selectedTheme;
  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.habits,
    required this.selectedQuotesCategories,
    required this.selectedTheme,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    List<Habit>? habits,
    List<String>? selectedQuotesCategories,
    String? selectedTheme,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      habits: habits ?? this.habits,
      selectedQuotesCategories: selectedQuotesCategories ?? this.selectedQuotesCategories,
      selectedTheme: selectedTheme ?? this.selectedTheme,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'habits': habits.map((x) => x.toMap()).toList(),
      'selectedQuotesCategories': selectedQuotesCategories,
      'selectedTheme': selectedTheme,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      habits: List<Habit>.from(map['habits']?.map((x) => Habit.fromMap(x))),
      selectedQuotesCategories: List<String>.from(map['selectedQuotesCategories']),
      selectedTheme: map['selectedTheme'] ?? '',
    );
  }


  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, username: $username, habits: $habits, selectedQuotesCategories: $selectedQuotesCategories, selectedTheme: $selectedTheme)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.uid == uid &&
      other.email == email &&
      other.username == username &&
      listEquals(other.habits, habits) &&
      listEquals(other.selectedQuotesCategories, selectedQuotesCategories) &&
      other.selectedTheme == selectedTheme;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      email.hashCode ^
      username.hashCode ^
      habits.hashCode ^
      selectedQuotesCategories.hashCode ^
      selectedTheme.hashCode;
  }
}
