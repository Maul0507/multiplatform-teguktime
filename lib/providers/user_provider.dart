import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teguk_time/providers/intensitas_provider.dart';
import 'package:teguk_time/providers/schedules_provider.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // ====== Getters ======
  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // 🔐 Login
  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _userService.login(email, password);
      // Load token stored by service
      _token = await _userService.loadToken();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _user = null;
      _token = null;
      _errorMessage = e.toString();
      notifyListeners();
    }
    _setLoading(false);
  }

  // 📝 Register
  Future<void> register(String name, String email, String password) async {
    _setLoading(true);
    try {
      final result = await _userService.register(
        name: name,
        email: email,
        password: password,
      );
      // After successful registration, load token
      _token = await _userService.loadToken();
      _successMessage = result;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _successMessage = null;
      _errorMessage = e.toString();
      notifyListeners();
    }
    _setLoading(false);
  }

  // 🚪 Logout
 Future<int?> getSavedIntensitasId() async {
  final prefs = await SharedPreferences.getInstance();
  final intensitasId = prefs.getInt('intensitasId');

  if (intensitasId == null || intensitasId == -1) {
    return null; // Anggap tidak ada data
  }

  return intensitasId;
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('intensitasId', -1); // ✅ Pastikan pakai await
  await prefs.setDouble('dailyTarget', 0.0); // juga ini kalau perlu reset

  _user = null;
  _token = null;
  notifyListeners();
}




  // ✅ Cek login status dan load user serta token
  Future<void> checkLoginStatus() async {
    _setLoading(true);
    final hasToken = await _userService.isLoggedIn();
    if (hasToken) {
      _token = await _userService.loadToken();
      try {
        _user = await _userService.getCurrentUser();
        _errorMessage = null;
      } catch (e) {
        _user = null;
        _errorMessage = e.toString();
      }
    } else {
      _user = null;
      _token = null;
    }
    _setLoading(false);
    notifyListeners();
  }

  // 🧍 Get user by ID (optional)
  Future<void> loadUserById(int id) async {
    _setLoading(true);
    try {
      _user = await _userService.getUserById(id);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
    notifyListeners();
  }

  // ✅ Update user name to API
  Future<void> updateUserName(String newName) async {
    if (_user == null) return;

    _setLoading(true);
    try {
      final updatedUser = _user!.copyWith(name: newName);
      final userFromApi = await _userService.updateUser(updatedUser);
      _user = userFromApi;
      _successMessage = 'Nama berhasil diubah';
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _successMessage = null;
      _errorMessage = e.toString();
      notifyListeners();
    }
    _setLoading(false);
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  // 📤 Ambil ID user saat ini
  int? get userId => _user?.id;

  // 🧪 Cek apakah user sudah login
  bool get isLoggedIn => _user != null && _token != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
