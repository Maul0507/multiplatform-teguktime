import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/intensitas_model.dart';
import '../providers/intensitas_provider.dart';
import '../providers/user_provider.dart';
import '../views/intensitas_form.dart';

class IntensitasScreen extends StatefulWidget {
  final Function()? onReturnToHome;

  const IntensitasScreen({super.key, this.onReturnToHome});

  @override
  State<IntensitasScreen> createState() => _IntensitasScreenState();
}

class _IntensitasScreenState extends State<IntensitasScreen> {
  final TextEditingController umurController = TextEditingController();
  final TextEditingController beratController = TextEditingController();
  final TextEditingController tinggiController = TextEditingController();

  String? selectedGender;
  String? selectedAktivitas;
  double? targetAir;
  late int userId;
  IntensitasModel? lastSubmittedData;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userId = userProvider.user?.id ?? 0;
    _cekIntensitasHariIni();
  }

  Future<void> _cekIntensitasHariIni() async {
    final intensitasProvider = Provider.of<IntensitasProvider>(context, listen: false);
    final data = await intensitasProvider.getIntensitasHariIni(userId);
    if (data != null) {
      setState(() {
        lastSubmittedData = data;
        targetAir = data.targetAir;
      });
    }
  }

Future<void> _submitFromWidget(double target, IntensitasModel model) async {
  final today = DateTime.now().toString().split(' ')[0]; // format YYYY-MM-DD

  if (lastSubmittedData?.tanggal == today) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Anda sudah mengisi intensitas hari ini."),
    ));
    return;
  }

  try {
    final intensitasProvider = Provider.of<IntensitasProvider>(context, listen: false);

    await intensitasProvider.addIntensitas(model);

    // ✅ Tambahkan ini agar target disimpan ke SharedPreferences
    intensitasProvider.setTargetAir(target.toInt());

    setState(() {
      lastSubmittedData = model;
      targetAir = target;
    });

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal menyimpan: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Intensitas Aktivitas")),
      body: lastSubmittedData != null
          ? _buildHasil(lastSubmittedData!)
          : IntensitasFormWidget(
              umurController: umurController,
              beratController: beratController,
              tinggiController: tinggiController,
              selectedGender: selectedGender,
              selectedAktivitas: selectedAktivitas,
              onChangedGender: (val) => setState(() => selectedGender = val),
              onChangedAktivitas: (val) => setState(() => selectedAktivitas = val),
              userId: userId,
              onSubmit: _submitFromWidget,
            ),
    );
  }

  Widget _buildHasil(IntensitasModel data) {
    final total = data.targetAir;
    final pembagian6 = (total / 6).round();
    final pembagian8 = (total / 8).round();
    final pembagian10 = (total / 10).round();

    final jadwal = generateJadwalMinum(total);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hasil Catatan Anda:", style: TextStyle(fontWeight: FontWeight.bold)),
            _row("Jenis Kelamin", data.jenisKelamin),
            _row("Umur", data.umur.toString()),
            _row("Berat", "${data.beratBadan} kg"),
            _row("Tinggi", "${data.tinggiBadan} cm"),
            _row("Aktivitas", data.aktivitas),
            SizedBox(height: 20),
            Text("Target Air Anda:", style: TextStyle(fontSize: 16)),
            Text("${data.targetAir.toStringAsFixed(0)} ml / hari",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("\uD83D\uDCA7 Pembagian Air Harian:", style: TextStyle(fontSize: 16)),
            Text("- 6 kali minum: $pembagian6 ml / sesi"),
            Text("- 8 kali minum: $pembagian8 ml / sesi"),
            Text("- 10 kali minum: $pembagian10 ml / sesi"),
            SizedBox(height: 20),
            Text("\uD83D\uDD53 Jadwal Minum (8x per hari):",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...jadwal
                .map((e) => Text("- ${e['waktu']}: ${e['jumlah']} ml"))
                .toList(),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => setState(() => lastSubmittedData = null),
              child: Text("Tambah Lagi Besok"),
            ),
            TextButton(
              onPressed: () {
                if (widget.onReturnToHome != null) {
                  widget.onReturnToHome!();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text("Kembali ke Beranda"),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> generateJadwalMinum(double totalAir) {
    final sesi = 8;
    final jumlahPerSesi = (totalAir / sesi).round();
    final waktu = ["07:00", "09:00", "11:00", "13:00", "15:00", "17:00", "19:00", "21:00"];
    return waktu.map((jam) => {"waktu": jam, "jumlah": "$jumlahPerSesi"}).toList();
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
}
