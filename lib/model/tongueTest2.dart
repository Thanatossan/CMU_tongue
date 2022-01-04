import 'dart:ffi';

final String tableTongueTest2 = 'tongueTest2';

class TongueTest2Fields {
  static final List<String> values = [
    /// Add all fields
    id, userId, time, type, setNewton , setKiloPascal,duration
  ];

  static final String id = '_id';
  static final String userId = 'userId';
  static final String time = 'time';
  static final String type = 'type';
  static final String setNewton = 'newton';
  static final String setKiloPascal = 'kiloPascal';
  static final String duration = 'duration';
}

class TongueTest2 {
  final int? id;
  final int? userId;
  final DateTime time;
  final String type;
  final double setNewton;
  final double setKiloPascal;
  final int duration;

  const TongueTest2({
    this.id,
    required this.userId,
    required this.time,
    required this.type,
    required this.setNewton,
    required this.setKiloPascal,
    required this.duration
  });

  TongueTest2 copy({
    int? id,
    int? userId,
    DateTime? time,
    String? type,
    double? newton,
    double? kiloPascal,
    int? duration
  }) =>
      TongueTest2(
          id: id ?? this.id,
          userId: userId ?? this.userId,
          time: time ?? this.time,
          type: type ?? this.type,
          setNewton: newton ?? this.setNewton,
          setKiloPascal: kiloPascal ?? this.setKiloPascal,
          duration: duration ?? this.duration
      );

  static TongueTest2 fromJson(Map<String, Object?> json) => TongueTest2(
    id: json[TongueTest2Fields.id] as int?,
    userId: json[TongueTest2Fields.userId] as int?,
    time: DateTime.parse(json[TongueTest2Fields.time] as String),
    type: json[TongueTest2Fields.type] as String,
    setNewton: json[TongueTest2Fields.setNewton] as double,
    setKiloPascal: json[TongueTest2Fields.setKiloPascal] as double,
    duration: json[TongueTest2Fields.duration] as int
  );

  Map<String, Object?> toJson() => {
    TongueTest2Fields.id: id,
    TongueTest2Fields.userId: userId,
    TongueTest2Fields.time: time.toIso8601String(),
    TongueTest2Fields.type: type,
    TongueTest2Fields.setNewton: setNewton,
    TongueTest2Fields.setKiloPascal: setKiloPascal,
    TongueTest2Fields.duration : duration
  };
}
