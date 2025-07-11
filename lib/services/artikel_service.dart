import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/artikel_model.dart';

class ArtikelService {
  final String baseUrl = ' https://6b36e71c2e32.ngrok-free.app/api'; // Ganti dengan base URL API kamu

  // GET semua artikel
  Future<List<ArtikelModel>> fetchArtikelList() async {
    final response = await http.get(Uri.parse('$baseUrl/artikel'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => ArtikelModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data artikel');
    }
  }

  // GET satu artikel
  Future<ArtikelModel> getArtikelById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/artikel/$id'));

    if (response.statusCode == 200) {
      return ArtikelModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengambil artikel');
    }
  }

  // POST artikel baru
  Future<ArtikelModel> createArtikel(ArtikelModel artikel) async {
    final response = await http.post(
      Uri.parse('$baseUrl/artikel'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(artikel.toJson()),
    );

    if (response.statusCode == 201) {
      return ArtikelModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal menambahkan artikel');
    }
  }

  // PUT update artikel
  Future<ArtikelModel> updateArtikel(ArtikelModel artikel) async {
    final response = await http.put(
      Uri.parse('$baseUrl/artikel/${artikel.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(artikel.toJson()),
    );

    if (response.statusCode == 200) {
      return ArtikelModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memperbarui artikel');
    }
  }

  // DELETE artikel
  Future<void> deleteArtikel(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/artikel/$id'));

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus artikel');
    }
  }
}
