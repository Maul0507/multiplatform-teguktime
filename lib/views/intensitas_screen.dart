import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/intensitas_model.dart';
import '../services/intensitas_service.dart';
import '../providers/user_provider.dart';

class IntensitasScreen extends StatefulWidget {
  final Function()? onReturnToHome;
  final Function(double ml) onTargetCalculated;

  const IntensitasScreen({
    super.key,
    this.onReturnToHome,
    required this.onTargetCalculated,
  });

  @override
  State<IntensitasScreen> createState() => _IntensitasScreenState();
}

class _IntensitasScreenState extends State<IntensitasScreen> {
  final TextEditingController umurController = TextEditingController();
  final TextEditingController beratController = TextEditingController();
  final TextEditingController tinggiController = TextEditingController();

  String? selectedGender;
  String? selectedAktivitas;
  bool submitted = false;
  double? targetAir;
  late int userId;

  List<Map<String, String>> riwayatData = [];

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userId = userProvider.user?.id ?? 0;
    _checkTodaySubmission();
  }

  void _checkTodaySubmission() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString('lastSubmittedDate_$userId');
    final today = DateTime.now().toString().split(' ')[0];

    if (lastDate == today) {
      final savedData = prefs.getStringList('riwayatData_$userId');
      if (savedData != null) {
        setState(() {
          submitted = true;
          riwayatData.add({
            'jenisKelamin': savedData[0],
            'umur': savedData[1],
            'berat': savedData[2],
            'tinggi': savedData[3],
            'aktivitas': savedData[4],
            'targetAir': savedData[5],
            'tanggal': today,
          });
          targetAir = double.tryParse(savedData[5]);
        });
      }
    }
  }

  Future<void> _submit() async {
    if (selectedGender == null ||
        selectedAktivitas == null ||
        umurController.text.isEmpty ||
        beratController.text.isEmpty ||
        tinggiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lengkapi semua data terlebih dahulu.')),
      );
      return;
    }

    final umur = int.tryParse(umurController.text) ?? 0;
    final berat = double.tryParse(beratController.text) ?? 0;
    final tinggi = double.tryParse(tinggiController.text) ?? 0;

    double faktor = selectedAktivitas == "Ringan"
        ? 30
        : selectedAktivitas == "Sedang"
        ? 35
        : 40;

    if (selectedGender == "Laki-laki") {
      faktor += umur < 30 ? 5 : (umur > 50 ? -3 : 0);
    } else {
      faktor += umur < 30 ? 0 : (umur > 50 ? -3 : -2);
    }

    targetAir = berat * faktor;
    widget.onTargetCalculated(targetAir!);

    final today = DateTime.now().toString().split(' ')[0];

    // Simpan ke SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSubmittedDate_$userId', today);
    await prefs.setStringList('riwayatData_$userId', [
      selectedGender!,
      umur.toString(),
      berat.toString(),
      tinggi.toString(),
      selectedAktivitas!,
      targetAir!.toStringAsFixed(0),
    ]);

    // Simpan ke database Laravel melalui API
    final intensitas = IntensitasModel(
      userId: userId,
      jenisKelamin: selectedGender!,
      umur: umur,
      beratBadan: berat,
      tinggiBadan: tinggi,
      aktivitas: selectedAktivitas!,
      targetAir: targetAir!,
      tanggal: today,
    );

    try {
      await IntensitasService().createIntensitas(intensitas);
    } catch (e) {
      debugPrint("Gagal menyimpan ke server: $e");
    }

    setState(() {
      submitted = true;
      riwayatData.add({
        'jenisKelamin': selectedGender!,
        'umur': umur.toString(),
        'berat': berat.toString(),
        'tinggi': tinggi.toString(),
        'aktivitas': selectedAktivitas!,
        'targetAir': targetAir!.toStringAsFixed(0),
        'tanggal': today,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Intensitas Aktivitas")),
      body: submitted ? _buildHasil() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          _dropdown("Jenis Kelamin", ["Laki-laki", "Perempuan"], (val) {
            setState(() => selectedGender = val);
          }, selectedGender),
          _textInput("Umur", umurController),
          _textInput("Berat Badan (kg)", beratController),
          _textInput("Tinggi Badan (cm)", tinggiController),
          _dropdown("Aktivitas", ["Ringan", "Sedang", "Berat"], (val) {
            setState(() => selectedAktivitas = val);
          }, selectedAktivitas),
          SizedBox(height: 20),
          ElevatedButton(onPressed: _submit, child: Text("Submit")),
        ],
      ),
    );
  }

  Widget _buildHasil() {
    final data = riwayatData.last;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hasil Catatan Anda:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          _row("Jenis Kelamin", data['jenisKelamin']),
          _row("Umur", data['umur']),
          _row("Berat", data['berat']),
          _row("Tinggi", data['tinggi']),
          _row("Aktivitas", data['aktivitas']),
          SizedBox(height: 20),
          Text("Target Air:", style: TextStyle(fontSize: 16)),
          Text(
            "${data['targetAir']} ml / hari",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: widget.onReturnToHome,
            child: Text("Kembali ke Beranda"),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(": ${value ?? '-'}")],
      ),
    );
  }

  Widget _textInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    List<String> items,
    Function(String?) onChanged,
    String? selected,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        value: selected,
        onChanged: onChanged,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
      ),
    );
  }
}
