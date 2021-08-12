final String tableNotes = 'notes';

class UserFields {
  static final List<String> values = [
    /// Add all fields
    id, isImportant, number, title, description, time
  ];

  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
}

class Users {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Users({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Users copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Users(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Users fromJson(Map<String, Object?> json) => Users(
        id: json[UserFields.id] as int?,
        isImportant: json[UserFields.isImportant] == 1,
        number: json[UserFields.number] as int,
        title: json[UserFields.title] as String,
        description: json[UserFields.description] as String,
        createdTime: DateTime.parse(json[UserFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        UserFields.id: id,
        UserFields.title: title,
        UserFields.isImportant: isImportant ? 1 : 0,
        UserFields.number: number,
        UserFields.description: description,
        UserFields.time: createdTime.toIso8601String(),
      };
}
