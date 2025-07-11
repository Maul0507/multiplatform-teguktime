import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/schedules_model.dart';

class SchedulesService {
  final String baseUrl =
      ' https://6b36e71c2e32.ngrok-free.app/api'; // Ganti URL sesuai backend kamu

  // GET semua jadwal (opsional: bisa tambahkan filter user_id)
  Future<List<SchedulesModel>> fetchSchedules({int? userId}) async {
    final url = userId != null
        ? '$baseUrl/schedules?user_id=$userId'
        : '$baseUrl/schedules';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      // Jika API memiliki field "data", ambil isinya
      final data = body is List ? body : body['data'];
      return List<SchedulesModel>.from(
        data.map((json) => SchedulesModel.fromJson(json)),
      );
    } else {
      throw Exception('Gagal mengambil data jadwal minum');
    }
  }

  // POST jadwal baru
  Future<SchedulesModel> addSchedule(SchedulesModel schedule) async {
    final response = await http.post(
      Uri.parse('$baseUrl/schedules'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(schedule.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body is Map<String, dynamic> ? body['data'] ?? body : body;
      return SchedulesModel.fromJson(data);
    } else {
      throw Exception('Gagal menambahkan jadwal: ${response.body}');
    }
  }

  // PUT / UPDATE jadwal
  Future<SchedulesModel> updateSchedule(SchedulesModel schedule) async {
    final response = await http.put(
      Uri.parse('$baseUrl/schedules/${schedule.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(schedule.toJson()),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body is Map<String, dynamic> ? body['data'] ?? body : body;
      return SchedulesModel.fromJson(data);
    } else {
      throw Exception('Gagal mengupdate jadwal: ${response.body}');
    }
  }

  // DELETE jadwal
  Future<void> deleteSchedule(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/schedules/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus jadwal: ${response.body}');
    }
  }
}
