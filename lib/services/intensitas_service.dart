import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/intensitas_model.dart';

class IntensitasService {
  final String baseUrl =
      'https://da48-36-69-117-160.ngrok-free.app/api'; // Ganti dengan URL API kamu

  // ✅ Ambil semua data intensitas (opsional, untuk admin atau debugging)
  Future<List<IntensitasModel>> fetchIntensitasList() async {
    final response = await http.get(Uri.parse('$baseUrl/intensitas'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => IntensitasModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data intensitas');
    }
  }

  // ✅ Ambil data intensitas berdasarkan ID intensitas
  Future<IntensitasModel> getIntensitasById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/intensitas/$id'));

    if (response.statusCode == 200) {
      return IntensitasModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengambil detail intensitas');
    }
  }

  // ✅ Ambil data intensitas terbaru berdasarkan ID user
  Future<IntensitasModel> getIntensitasByUserId(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/intensitas/user/$userId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return IntensitasModel.fromJson(data);
    } else {
      throw Exception('Gagal mengambil intensitas berdasarkan user');
    }
  }

  // ✅ Tambahkan data intensitas baru
  Future<IntensitasModel> createIntensitas(IntensitasModel data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/intensitas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 201) {
      return IntensitasModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal menambahkan data intensitas');
    }
  }

  // ✅ Perbarui data intensitas berdasarkan ID
  Future<IntensitasModel> updateIntensitas(IntensitasModel data) async {
    if (data.id == null) {
      throw Exception('ID intensitas tidak boleh kosong untuk update');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/intensitas/${data.id}'),
      headers: {'Content-Type': 'application/json'},
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
    final response = await http.delete(Uri.parse('$baseUrl/intensitas/$id'));

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus data intensitas');
    }
  }
}
