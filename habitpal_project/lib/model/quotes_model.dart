import 'dart:convert';

class QuotesModel {
  final String uid;
  final String description;
  final String type;
  QuotesModel({
    required this.uid,
    required this.description,
    required this.type,
  });

  QuotesModel copyWith({
    String? uid,
    String? description,
    String? type,
  }) {
    return QuotesModel(
      uid: uid ?? this.uid,
      description: description ?? this.description,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'description': description,
      'type': type,
    };
  }

  factory QuotesModel.fromMap(Map<String, dynamic> map) {
    return QuotesModel(
      uid: map['uid'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory QuotesModel.fromJson(String source) => QuotesModel.fromMap(json.decode(source));

  @override
  String toString() => 'QuotesModel(uid: $uid, description: $description, type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is QuotesModel &&
      other.uid == uid &&
      other.description == description &&
      other.type == type;
  }

  @override
  int get hashCode => uid.hashCode ^ description.hashCode ^ type.hashCode;
}
