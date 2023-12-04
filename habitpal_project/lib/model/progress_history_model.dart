import 'dart:convert';

class ProgressEntry {
  final DateTime date;
  final bool completed;

  ProgressEntry({
    required this.date,
    required this.completed,
  });

  ProgressEntry copyWith({
    DateTime? date,
    bool? completed,
  }) {
    return ProgressEntry(
      date: date ?? this.date,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'completed': completed,
    };
  }

  factory ProgressEntry.fromMap(Map<String, dynamic> map) {
    return ProgressEntry(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      completed: map['completed'] ?? false,
    );
  }

  @override
  String toString() => 'ProgressEntry(date: $date, completed: $completed)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProgressEntry &&
      other.date == date &&
      other.completed == completed;
  }

  @override
  int get hashCode => date.hashCode ^ completed.hashCode;
}
