class SchedulesModel {
  final int id;
  final int userId;
  final String scheduleTime;
  final int volumeMl;
  final DateTime createdAt;
  final DateTime updatedAt;

  SchedulesModel({
    required this.id,
    required this.userId,
    required this.scheduleTime,
    required this.volumeMl,
    required this.createdAt,
    required this.updatedAt,
  });

  // Buat model dari JSON
  factory SchedulesModel.fromJson(Map<String, dynamic> json) {
    return SchedulesModel(
      id: json['id'],
      userId: json['user_id'],
      scheduleTime: json['schedule_time'],
      volumeMl: json['volume_ml'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Konversi model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'schedule_time': scheduleTime,
      'volume_ml': volumeMl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
