import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/intensitas_model.dart';
import '../services/intensitas_service.dart';

class IntensitasProvider with ChangeNotifier {
  final IntensitasService _intensitasService = IntensitasService();

  List<IntensitasModel> _list = [];
  IntensitasModel? _selected;
  bool _isLoading = false;

  int? _targetAir;
  int? get targetAir => _targetAir;

  List<IntensitasModel> get list => _list;
  IntensitasModel? get selected => _selected;
  bool get isLoading => _isLoading;

void setTargetAir(int target) async {
  _targetAir = target;
  notifyListeners();

  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('dailyTarget', target.toDouble());

  print('Saved target: $target'); // Tambahan debug
}



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

  Future<void> addIntensitas(IntensitasModel data) async {
    try {
      final newData = await _intensitasService.createIntensitas(data);
      _list.add(newData);
      _targetAir = newData.targetAir.toInt();
      notifyListeners();
    } catch (e) {
      throw Exception('Error addIntensitas: $e');
    }
  }

  /// ✅ Mengecek apakah user sudah mengisi intensitas hari ini
  Future<IntensitasModel?> getIntensitasHariIni(int userId) async {
    try {
      final data = await _intensitasService.getIntensitasHariIni(userId);
      return data;
    } catch (e) {
      print('Error getIntensitasHariIni: $e');
      return null;
    }
  }

  /// Optional: Jika ingin menyimpan data yang dipilih (misalnya untuk detail atau edit)
  void select(IntensitasModel data) {
    _selected = data;
    notifyListeners();
  }

  /// Optional: Reset pilihan intensitas
  void clearSelected() {
    _selected = null;
    notifyListeners();
  }
  
}
