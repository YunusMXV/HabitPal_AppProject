

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:habitpal_project/model/habit_model.dart';

class UserModel {
  final String uid;
  final String email;
  final String username; // You may want to include this for personalization
  final List<Habit> habits;
  final List<String> selectedQuotesCategories;
  final String selectedTheme;
  final int maxStreak;
  final int currentStreak;
  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.habits,
    required this.selectedQuotesCategories,
    required this.selectedTheme,
    required this.maxStreak,
    required this.currentStreak,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    List<Habit>? habits,
    List<String>? selectedQuotesCategories,
    String? selectedTheme,
    int? maxStreak,
    int? currentStreak,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      habits: habits ?? this.habits,
      selectedQuotesCategories: selectedQuotesCategories ?? this.selectedQuotesCategories,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      maxStreak: maxStreak ?? this.maxStreak,
      currentStreak: currentStreak ?? this.currentStreak,
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
      'maxStreak': maxStreak,
      'currentStreak': currentStreak,
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
      maxStreak: map['maxStreak']?.toInt() ?? 0,
      currentStreak: map['currentStreak']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, username: $username, habits: $habits, selectedQuotesCategories: $selectedQuotesCategories, selectedTheme: $selectedTheme, maxStreak: $maxStreak, currentStreak: $currentStreak)';
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
      other.selectedTheme == selectedTheme &&
      other.maxStreak == maxStreak &&
      other.currentStreak == currentStreak;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      email.hashCode ^
      username.hashCode ^
      habits.hashCode ^
      selectedQuotesCategories.hashCode ^
      selectedTheme.hashCode ^
      maxStreak.hashCode ^
      currentStreak.hashCode;
  }
}
