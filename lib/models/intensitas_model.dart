class IntensitasModel {
  final int? id;
  final int userId;
  final String jenisKelamin;
  final int umur;
  final double beratBadan;
  final double tinggiBadan;
  final String aktivitas;
  final double targetAir;
  final String tanggal;

  IntensitasModel({
    this.id,
    required this.userId,
    required this.jenisKelamin,
    required this.umur,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.aktivitas,
    required this.targetAir,
    required this.tanggal,
  });

  factory IntensitasModel.fromJson(Map<String, dynamic> json) {
    return IntensitasModel(
      id: json['id'],
      userId: json['user_id'],
      jenisKelamin: json['jenis_kelamin'],
      umur: json['umur'],
      beratBadan: (json['berat_badan'] as num).toDouble(),
      tinggiBadan: (json['tinggi_badan'] as num).toDouble(),
      aktivitas: json['aktivitas'],
      targetAir: (json['target_air'] as num).toDouble(),
      tanggal: json['tanggal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'jenis_kelamin': jenisKelamin,
      'umur': umur,
      'berat_badan': beratBadan,
      'tinggi_badan': tinggiBadan,
      'aktivitas': aktivitas,
      'target_air': targetAir,
      'tanggal': tanggal,
    };
  }
}
