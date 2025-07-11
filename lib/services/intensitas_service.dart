import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/intensitas_model.dart';

class IntensitasService {
  final String baseUrl = 'https://6b36e71c2e32.ngrok-free.app/api'; // ✅ Ubah sesuai URL ngrok-mu

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ✅ Ambil semua data intensitas
  Future<List<IntensitasModel>> fetchIntensitasList() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/intensitas'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => IntensitasModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data intensitas');
    }
  }

  // ✅ Ambil intensitas hari ini berdasarkan user_id
  Future<IntensitasModel?> getIntensitasHariIni(int userId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/intensitas/user/$userId/hari-ini'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return IntensitasModel.fromJson(data);
    } else if (response.statusCode == 404) {
      return null; // ✅ Tidak ada data hari ini
    } else {
      throw Exception('Gagal memeriksa intensitas hari ini');
    }
  }

  // ✅ Ambil detail intensitas berdasarkan id
  Future<IntensitasModel> getIntensitasById(int id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/intensitas/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return IntensitasModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengambil detail intensitas');
    }
  }

  // ✅ Ambil intensitas terakhir berdasarkan user_id
  Future<IntensitasModel> getIntensitasByUserId(int userId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/intensitas/user/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return IntensitasModel.fromJson(data);
    } else {
      throw Exception('Gagal mengambil intensitas berdasarkan user');
    }
  }

  // ✅ Ambil intensitas berdasarkan user dan tanggal spesifik (opsional jika backend mendukung)
  Future<IntensitasModel?> getIntensitasByUserIdAndTanggal(int userId, String tanggal) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/intensitas/$userId/$tanggal'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['intensitas'] != null) {
        return IntensitasModel.fromJson(data['intensitas']);
      }
    }
    return null;
  }

  // ✅ Tambah data intensitas
  Future<IntensitasModel> createIntensitas(IntensitasModel data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/intensitas'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body)['data'];
      return IntensitasModel.fromJson(responseData);
    } else {
      final error = jsonDecode(response.body)['message'] ?? 'Gagal menambahkan data intensitas';
      throw Exception(error);
    }
  }

  // ✅ Update data intensitas
  Future<IntensitasModel> updateIntensitas(IntensitasModel data) async {
    if (data.id == null) throw Exception('ID intensitas tidak boleh kosong untuk update');

    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/intensitas/${data.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      return IntensitasModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memperbarui data intensitas');
    }
  }

  // ✅ Hapus data intensitas
  Future<void> deleteIntensitas(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/intensitas/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus data intensitas');
    }
  }
}
