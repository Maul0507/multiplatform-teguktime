import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/schedules_model.dart';

class SchedulesService {
  final String baseUrl = 'https://6b36e71c2e32.ngrok-free.app/api'; // Ganti sesuai URL backend-mu

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<ScheduleModel>> getSchedulesByIntensitas(int intensitasId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/schedules/intensitas/$intensitasId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => ScheduleModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat jadwal minum');
    }
  }

// Future<ScheduleModel> createSchedule({
//   required int intensitasId,
//   required String scheduleTime,
//   required int volumeMl,
// }) async {
//   final token = await _getToken();

//   final response = await http.post(
//     Uri.parse('$baseUrl/drink-schedules'),
//     headers: {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode({
//       'intensitas_id': intensitasId,
//       'schedule_time': scheduleTime,
//       'volume_ml': volumeMl,
//     }),
//   );

//   print('📡 Request Body: ${{
//     'intensitas_id': intensitasId,
//     'schedule_time': scheduleTime,
//     'volume_ml': volumeMl,
//   }}');

//   print('📡 Status Code: ${response.statusCode}');
//   print('📡 Response Body: ${response.body}');

//   if (response.statusCode == 201) {
//     final responseData = jsonDecode(response.body)['data'];
//     return ScheduleModel.fromJson(responseData);
//   } else {
//     final error = jsonDecode(response.body)['message'] ?? 'Gagal menambahkan jadwal';
//     throw Exception(error);
//   }
// }


 Future<void> deleteSchedule(int id) async {
  final token = await _getToken(); // metode ambil token auth
  final response = await http.delete(
    Uri.parse('https://6b36e71c2e32.ngrok-free.app/api/drink-schedules/$id'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal menghapus jadwal');
  }
}



  Future<ScheduleModel?> createSchedule({
    required int intensitasId,
    required String scheduleTime,
    required int volumeMl,
    String? token
  }) async {
    final url = Uri.parse('https://6b36e71c2e32.ngrok-free.app/api/drink-schedules'); 
    print(url);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',},
      body: jsonEncode({
        'intensitas_id': intensitasId,
        'schedule_time': scheduleTime,
        'volume_ml': volumeMl,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return ScheduleModel.fromJson(json['data']);
    } else {
      print('Gagal membuat jadwal minum: ${response.body}');
      return null;
    }
  }


 Future<List<ScheduleModel>> getSchedulesByIntensitasId(int intensitasId, String? token) async {
  final url = Uri.parse('https://6b36e71c2e32.ngrok-free.app/api/drink-schedules/intensitas/$intensitasId');

  final response = await http.get(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      // Jika kamu menggunakan token otentikasi, tambahkan baris berikut:
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final decoded = json.decode(response.body);
    final List<dynamic> data = decoded['data'];
    return data.map((json) => ScheduleModel.fromJson(json)).toList();
  } else {
    throw Exception('Gagal memuat jadwal minum dari intensitas ID');
  }
}

}
