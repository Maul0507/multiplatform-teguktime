import 'package:flutter/material.dart';
import '../models/intensitas_model.dart';
import '../services/intensitas_service.dart';

class IntensitasProvider with ChangeNotifier {
  final IntensitasService _intensitasService = IntensitasService();

  List<IntensitasModel> _list = [];
  IntensitasModel? _selected;
  bool _isLoading = false;

  int _targetAir = 2000; // Default target air harian
  int get targetAir => _targetAir;

  List<IntensitasModel> get list => _list;
  IntensitasModel? get selected => _selected;
  bool get isLoading => _isLoading;

  void setTargetAir(int ml) {
    _targetAir = ml;
    notifyListeners();
  }

  // 🔄 Ambil semua data intensitas (opsional)
  Future<void> fetchIntensitasList() async {
    _isLoading = true;
    notifyListeners();

    try {
      _list = await _intensitasService.fetchIntensitasList();
    } catch (e) {
      print('Error fetchIntensitasList: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // 🔍 Ambil data intensitas berdasarkan ID
  Future<void> getIntensitasById(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selected = await _intensitasService.getIntensitasById(id);
    } catch (e) {
      print('Error getIntensitasById: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // ✅ Ambil target air dari backend berdasarkan userId
  Future<void> getTargetAirByUserId(int userId) async {
    try {
      final intensitas = await _intensitasService.getIntensitasByUserId(userId);
      _targetAir = intensitas.targetAir?.toInt() ?? 2000;
      notifyListeners();
    } catch (e) {
      print('Error getTargetAirByUserId: $e');
    }
  }

  // ➕ Tambah data baru
  Future<void> addIntensitas(IntensitasModel data) async {
    try {
      final newData = await _intensitasService.createIntensitas(data);
      _list.add(newData);

      // Set target setelah berhasil ditambahkan
      _targetAir = newData.targetAir?.toInt() ?? 2000;
      notifyListeners();
    } catch (e) {
      print('Error addIntensitas: $e');
    }
  }

  // 🔄 Update data
  Future<void> updateIntensitas(IntensitasModel data) async {
    try {
      final updated = await _intensitasService.updateIntensitas(data);
      final index = _list.indexWhere((e) => e.id == data.id);
      if (index != -1) {
        _list[index] = updated;
      }

      _targetAir = updated.targetAir?.toInt() ?? 2000;
      notifyListeners();
    } catch (e) {
      print('Error updateIntensitas: $e');
    }
  }

  // ❌ Hapus data
  Future<void> deleteIntensitas(int id) async {
    try {
      await _intensitasService.deleteIntensitas(id);
      _list.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleteIntensitas: $e');
    }
  }

  void clearSelected() {
    _selected = null;
    notifyListeners();
  }
}
