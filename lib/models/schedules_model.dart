class ScheduleModel {
  final int id;
  final int intensitasId;
  final String scheduleTime;
  final int volumeMl;

  ScheduleModel({
    required this.id,
    required this.intensitasId,
    required this.scheduleTime,
    required this.volumeMl,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],
      intensitasId: json['intensitas_id'],
      scheduleTime: json['schedule_time'],
      volumeMl: json['volume_ml'],
    );
  }
}
