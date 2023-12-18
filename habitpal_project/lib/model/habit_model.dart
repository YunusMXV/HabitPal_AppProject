import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:habitpal_project/model/progress_history_model.dart';
class Habit {
  final String habitId;
  final String habitTitle;
  final String description;
  final String category;
  final Set<String> targetCompletionDays;
  final List<ProgressEntry> progressHistory;
  final DateTime completionDeadline;

  Habit({
    required this.habitId,
    required this.habitTitle,
    required this.description,
    required this.category,
    required this.targetCompletionDays,
    required this.progressHistory,
    required this.completionDeadline,
  });

  Habit copyWith({
    String? habitId,
    String? habitTitle,
    String? description,
    String? category,
    Set<String>? targetCompletionDays,
    List<ProgressEntry>? progressHistory,
    DateTime? completionDeadline,
  }) {
    return Habit(
      habitId: habitId ?? this.habitId,
      habitTitle: habitTitle ?? this.habitTitle,
      description: description ?? this.description,
      category: category ?? this.category,
      targetCompletionDays: targetCompletionDays ?? this.targetCompletionDays,
      progressHistory: progressHistory ?? this.progressHistory,
      completionDeadline: completionDeadline ?? this.completionDeadline,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'habitId': habitId,
      'habitTitle': habitTitle,
      'description': description,
      'category': category,
      'targetCompletionDays': targetCompletionDays.toList(),
      'progressHistory': progressHistory.map((x) => x.toMap()).toList(),
      'completionDeadline': completionDeadline.millisecondsSinceEpoch,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      habitId: map['habitId'] ?? '',
      habitTitle: map['habitTitle'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      targetCompletionDays: Set<String>.from(map['targetCompletionDays']),
      progressHistory: List<ProgressEntry>.from(map['progressHistory']?.map((x) => ProgressEntry.fromMap(x))),
      completionDeadline: DateTime.fromMillisecondsSinceEpoch(map['completionDeadline']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Habit.fromJson(String source) => Habit.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Habit(habitId: $habitId, habitTitle: $habitTitle, description: $description, category: $category, targetCompletionDays: $targetCompletionDays, progressHistory: $progressHistory, completionDeadline: $completionDeadline)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Habit &&
      other.habitId == habitId &&
      other.habitTitle == habitTitle &&
      other.description == description &&
      other.category == category &&
      setEquals(other.targetCompletionDays, targetCompletionDays) &&
      listEquals(other.progressHistory, progressHistory) &&
      other.completionDeadline == completionDeadline;
  }

  @override
  int get hashCode {
    return habitId.hashCode ^
      habitTitle.hashCode ^
      description.hashCode ^
      category.hashCode ^
      targetCompletionDays.hashCode ^
      progressHistory.hashCode ^
      completionDeadline.hashCode;
  }
}
