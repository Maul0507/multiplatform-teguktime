import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // ====== Getters ======
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // 🔐 Login
  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _userService.login(email, password);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _user = null;
      _errorMessage = e.toString();
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
      _successMessage = result;
      _errorMessage = null;
    } catch (e) {
      _successMessage = null;
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  // ✅ Update user name to API
  Future<void> updateUserName(String newName) async {
    if (_user == null) return;

    _setLoading(true);
    try {
      // Buat user baru dengan nama baru
      final updatedUser = _user!.copyWith(name: newName);

      // Kirim ke backend
      final userFromApi = await _userService.updateUser(updatedUser);

      // Update lokal
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

  // 🚪 Logout
  Future<void> logout() async {
    await _userService.logout();
    _user = null;
    notifyListeners();
  }

  // ✅ Cek login status
  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _userService.isLoggedIn();
    if (isLoggedIn) {
      try {
        _user = await _userService.getCurrentUser();
        _errorMessage = null;
      } catch (e) {
        _user = null;
        _errorMessage = e.toString();
      }
      notifyListeners();
    }
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
  }

  // 🔁 Set user secara manual dari backend (misalnya setelah login silent)
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  // 📤 Ambil ID user saat ini
  int? get userId => _user?.id;

  // 🧪 Cek apakah user sudah login
  bool get isLoggedIn => _user != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
