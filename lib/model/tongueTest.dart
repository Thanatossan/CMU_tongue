import 'dart:ffi';

final String tableTongueTest = 'tongueTest';

class TongueTestFields {
  static final List<String> values = [
    /// Add all fields
    id, userId, time, type, newton , kiloPascal
  ];

  static final String id = '_id';
  static final String userId = 'userId';
  static final String time = 'time';
  static final String type = 'type';
  static final String newton = 'newton';
  static final String kiloPascal = 'kiloPascal';
}

class TongueTest {
  final int? id;
  final int? userId;
  final DateTime time;
  final String type;
  final double newton;
  final double kiloPascal;

  const TongueTest({
    this.id,
    required this.userId,
    required this.time,
    required this.type,
    required this.newton,
    required this.kiloPascal
  });

  TongueTest copy({
    int? id,
    int? userId,
    DateTime? time,
    String? type,
    double? newton,
    double? kiloPascal,
  }) =>
      TongueTest(
          id: id ?? this.id,
          userId: userId ?? this.userId,
          time: time ?? this.time,
          type: type ?? this.type,
          newton: newton ?? this.newton,
          kiloPascal: kiloPascal ?? this.kiloPascal
      );

  static TongueTest fromJson(Map<String, Object?> json) => TongueTest(
    id: json[TongueTestFields.id] as int?,
    userId: json[TongueTestFields.userId] as int?,
    time: DateTime.parse(json[TongueTestFields.time] as String),
    type: json[TongueTestFields.type] as String,
    newton: json[TongueTestFields.newton] as double,
    kiloPascal: json[TongueTestFields.kiloPascal] as double,
  );

  Map<String, Object?> toJson() => {
    TongueTestFields.id: id,
    TongueTestFields.userId: userId,
    TongueTestFields.time: time.toIso8601String(),
    TongueTestFields.type: type,
    TongueTestFields.newton: newton,
    TongueTestFields.kiloPascal: kiloPascal,
  };
}
