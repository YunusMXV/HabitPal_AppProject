import 'package:flutter/foundation.dart';

import 'package:habitpal_project/model/progress_history_model.dart';
class Habit { //not fixed open to changes, I think we should add weekdays option final Set<DayOfWeek> targetCompletionDays;
  final String habitId;
  final String description;
  final String category;
  final DateTime targetCompletionDate;
  final List<ProgressEntry> progressHistory;

  Habit({
    required this.habitId,
    required this.description,
    required this.category,
    required this.targetCompletionDate,
    required this.progressHistory,
  });

  Habit copyWith({
    String? habitId,
    String? description,
    String? category,
    DateTime? targetCompletionDate,
    List<ProgressEntry>? progressHistory,
  }) {
    return Habit(
      habitId: habitId ?? this.habitId,
      description: description ?? this.description,
      category: category ?? this.category,
      targetCompletionDate: targetCompletionDate ?? this.targetCompletionDate,
      progressHistory: progressHistory ?? this.progressHistory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'habitId': habitId,
      'description': description,
      'category': category,
      'targetCompletionDate': targetCompletionDate.millisecondsSinceEpoch,
      'progressHistory': progressHistory.map((x) => x.toMap()).toList(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      habitId: map['habitId'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      targetCompletionDate: DateTime.fromMillisecondsSinceEpoch(map['targetCompletionDate']),
      progressHistory: List<ProgressEntry>.from(map['progressHistory']?.map((x) => ProgressEntry.fromMap(x))),
    );
  }


  @override
  String toString() {
    return 'Habit(habitId: $habitId, description: $description, category: $category, targetCompletionDate: $targetCompletionDate, progressHistory: $progressHistory)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Habit &&
      other.habitId == habitId &&
      other.description == description &&
      other.category == category &&
      other.targetCompletionDate == targetCompletionDate &&
      listEquals(other.progressHistory, progressHistory);
  }

  @override
  int get hashCode {
    return habitId.hashCode ^
      description.hashCode ^
      category.hashCode ^
      targetCompletionDate.hashCode ^
      progressHistory.hashCode;
  }
}
