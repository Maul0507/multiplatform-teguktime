import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/intensitas_provider.dart';

class IntensitasResultWidget extends StatelessWidget {
  final int userId;
  final Function()? onReturn;

  const IntensitasResultWidget({
    super.key,
    required this.userId,
    this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IntensitasProvider>(context);
    final today = DateTime.now().toString().split(' ')[0];
    final data = provider.list.where((i) => i.tanggal == today && i.userId == userId).lastOrNull;

    if (data == null) {
      return const Center(child: Text("Data tidak ditemukan"));
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Hasil Catatan Anda:", style: TextStyle(fontWeight: FontWeight.bold)),
          _row("Jenis Kelamin", data.jenisKelamin),
          _row("Umur", data.umur.toString()),
          _row("Berat", data.beratBadan.toString()),
          _row("Tinggi", data.tinggiBadan.toString()),
          _row("Aktivitas", data.aktivitas),
          const SizedBox(height: 20),
          const Text("Target Air:", style: TextStyle(fontSize: 16)),
          Text(
            "${data.targetAir?.toStringAsFixed(0)} ml / hari",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onReturn,
            child: const Text("Kembali ke Beranda"),
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
        children: [
          Text(label),
          Text(": ${value ?? '-'}"),
        ],
      ),
    );
  }
}
