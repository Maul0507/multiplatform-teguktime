import 'package:flutter/material.dart';
import '../models/schedules_model.dart';
import '../services/schedules_service.dart';

class SchedulesProvider with ChangeNotifier {
  final SchedulesService _service = SchedulesService();

  List<SchedulesModel> _schedules = [];
  bool _isLoading = false;
  String? _error;

  List<SchedulesModel> get schedules => _schedules;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Ambil semua jadwal
  Future<void> fetchSchedules() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _schedules = await _service.fetchSchedules();

      // Urutkan berdasarkan waktu
      _schedules.sort((a, b) => a.scheduleTime.compareTo(b.scheduleTime));
    } catch (e) {
      _error = 'Fetch failed: $e';
      print(_error);
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Tambah jadwal baru
  Future<void> addSchedule(SchedulesModel schedule) async {
    try {
      final newSchedule = await _service.addSchedule(schedule);
      _schedules.add(newSchedule);

      // Urutkan ulang
      _schedules.sort((a, b) => a.scheduleTime.compareTo(b.scheduleTime));
      notifyListeners();
    } catch (e) {
      _error = 'Add failed: $e';
      print(_error);
    }
  }

  /// Update jadwal berdasarkan ID
  Future<void> updateSchedule(SchedulesModel schedule) async {
    try {
      final updated = await _service.updateSchedule(schedule);
      final index = _schedules.indexWhere((s) => s.id == schedule.id);
      if (index != -1) {
        _schedules[index] = updated;

        // Urutkan ulang
        _schedules.sort((a, b) => a.scheduleTime.compareTo(b.scheduleTime));
        notifyListeners();
      }
    } catch (e) {
      _error = 'Update failed: $e';
      print(_error);
    }
  }

  /// Hapus jadwal berdasarkan ID
  Future<void> removeSchedule(int id) async {
    try {
      await _service.deleteSchedule(id);
      _schedules.removeWhere((s) => s.id == id);
      notifyListeners();
    } catch (e) {
      _error = 'Delete failed: $e';
      print(_error);
    }
  }

  /// Dapatkan semua jadwal milik user tertentu
  List<SchedulesModel> userSchedules(int userId) {
    return _schedules.where((s) => s.userId == userId).toList();
  }

  /// (Opsional) Dapatkan jadwal hanya untuk hari ini
  List<SchedulesModel> todaySchedules(int userId) {
    final today = DateTime.now();
    return _schedules.where((s) {
      return s.userId == userId &&
          s.createdAt.year == today.year &&
          s.createdAt.month == today.month &&
          s.createdAt.day == today.day;
    }).toList();
  }

  /// Kosongkan semua data (misal setelah logout)
  void clearSchedules() {
    _schedules.clear();
    notifyListeners();
  }
}
