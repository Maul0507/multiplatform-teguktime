import 'package:flutter/material.dart';
import '../models/intensitas_model.dart';

class IntensitasFormWidget extends StatelessWidget {
  final TextEditingController umurController;
  final TextEditingController beratController;
  final TextEditingController tinggiController;
  final String? selectedGender;
  final String? selectedAktivitas;
  final Function(String?) onChangedGender;
  final Function(String?) onChangedAktivitas;
  final Function(double, IntensitasModel) onSubmit;
  final int userId;

  const IntensitasFormWidget({
    super.key,
    required this.umurController,
    required this.beratController,
    required this.tinggiController,
    required this.selectedGender,
    required this.selectedAktivitas,
    required this.onChangedGender,
    required this.onChangedAktivitas,
    required this.onSubmit,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          _dropdown("Jenis Kelamin", ["Laki-laki", "Perempuan"], selectedGender, onChangedGender),
          _input("Umur", umurController),
          _input("Berat Badan (kg)", beratController),
          _input("Tinggi Badan (cm)", tinggiController),
          _dropdown("Aktivitas", ["Ringan", "Sedang", "Berat"], selectedAktivitas, onChangedAktivitas),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (selectedGender == null ||
                  selectedAktivitas == null ||
                  umurController.text.isEmpty ||
                  beratController.text.isEmpty ||
                  tinggiController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi semua data')));
                return;
              }

              final umur = int.parse(umurController.text);
              final berat = double.parse(beratController.text);
              final tinggi = double.parse(tinggiController.text);

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

              final target = berat * faktor;
              final today = DateTime.now().toString().split(' ')[0];

              final data = IntensitasModel(
                userId: userId,
                jenisKelamin: selectedGender!,
                umur: umur,
                beratBadan: berat,
                tinggiBadan: tinggi,
                aktivitas: selectedAktivitas!,
                targetAir: target,
                tanggal: today,
              );

              onSubmit(target, data);
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  Widget _input(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    List<String> items,
    String? selected,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        value: selected,
        onChanged: onChanged,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      ),
    );
  }
}
