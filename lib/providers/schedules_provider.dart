import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teguk_time/providers/user_provider.dart';
import '../models/schedules_model.dart';
import '../services/schedules_service.dart';

class SchedulesProvider extends ChangeNotifier {
  final SchedulesService _service = SchedulesService();
  List<ScheduleModel> _schedules = [];

  List<ScheduleModel> get schedules => _schedules;

  Future<void> loadSchedules(int intensitasId) async {
    try {
      _schedules = await _service.getSchedulesByIntensitas(intensitasId);
      notifyListeners();
    } catch (e) {
      print("Error saat loadSchedules: $e");
    }
  }

   Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Future<void> addSchedule(ScheduleModel model) async {
  //   try {
  //     final newSchedule = await _service.addSchedule(model);
  //     _schedules.add(newSchedule);
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error saat addSchedule: $e");
  //   }
  // }

  Future<void> addSchedule({
  required BuildContext context,
  required int intensitasId,
  required String scheduleTime,
  required int volumeMl,
}) async {
  try {
    print('🔁 Memulai request ke backend...');

 final token = await _getToken();
    final newSchedule = await _service.createSchedule(
      token: token,
      intensitasId: intensitasId,
      scheduleTime: scheduleTime,
      volumeMl: volumeMl,
    );

    print('✅ Respon backend: $newSchedule');
    // _list.add(newSchedule);
    notifyListeners();
  } catch (e) {
    print('❌ Gagal mengirim ke backend: $e');
    rethrow;
  }
}

 Future<void> deleteSchedule(int id) async {
    try {
      print('Menghapus id: $id'); // ⬅️ DEBUG
      await _service.deleteSchedule(id);
      _schedules.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      print("Error saat deleteSchedule: $e");
    }
 }


  Future<void> fetchSchedulesByIntensitasId(int intensitasId) async {
    // _isLoading = true;
    notifyListeners();
final token = await _getToken();
    try {
      _schedules = await _service.getSchedulesByIntensitasId(intensitasId, token);
    } catch (e) {
      print('❌ Error: $e');
      _schedules = [];
    }

    // _isLoading = false;
    notifyListeners();
  }
}
