import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../config/api_config.dart';

class UserService {
  final String baseUrl = ApiConfig.baseUrl;

  // ================================
  // 🔐 AUTH SECTION
  // ================================

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConfig.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'] ?? data['access_token'];
      final user = User.fromJson(data['user_data']);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return user;
    } else {
      throw Exception('Login gagal: ${response.body}');
    }
  }

  Future<String> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final token = data['access_token'] ?? data['token'];
      final prefs = await SharedPreferences.getInstance();
      if (token != null) {
        await prefs.setString('token', token);
      }
      return data['message'] ?? 'Registrasi berhasil';
    } else {
      final message = data['message'] ?? 'Register gagal';
      throw Exception(message);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    }

    await prefs.remove('token');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<User> getCurrentUser() async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Gagal mengambil user aktif');
    }
  }

  // ================================
  // 📦 USER CRUD
  // ================================

  Future<List<User>> fetchUsers() async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data user');
    }
  }

  Future<User> getUserById(int id) async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.get(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengambil data user');
    }
  }

  Future<User> createUser(User user) async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal menambahkan user');
    }
  }

  Future<User> updateUser(User user) async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.put(
      Uri.parse('$baseUrl/users/${user.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': user.name}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return User.fromJson(data['user']);
    } else {
      throw Exception(data['message'] ?? 'Gagal memperbarui user');
    }
  }

  Future<void> deleteUser(int id) async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus user');
    }
  }
}
