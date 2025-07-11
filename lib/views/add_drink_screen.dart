import 'package:flutter/material.dart';
import 'wave_clipper.dart'; // Pastikan file WaveClipper terhubung.

class AddDrinkScreen extends StatefulWidget {
  final Map<String, dynamic>? editLog;

  AddDrinkScreen({this.editLog, required num maxAmount});

  @override
  _AddDrinkScreenState createState() => _AddDrinkScreenState();
}

class _AddDrinkScreenState extends State<AddDrinkScreen> {
  late double _amount;
  late DateTime _selectedTime;

  @override
  void initState() {
    super.initState();
    _amount = widget.editLog?['amount']?.toDouble() ?? 200;
    _selectedTime = widget.editLog?['time'] ?? DateTime.now();
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime),
    );
    if (time != null) {
      final now = DateTime.now();
      setState(() {
        _selectedTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editLog != null;

    return Scaffold(
      body: Column(
        children: [
          // Wave Header dengan lapisan tumpang tindih
          Stack(
            children: [
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 180,
                  color: Colors.lightBlue[100], // Warna lapisan pertama
                ),
              ),
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 160,
                  color: Colors.lightBlue[300], // Warna lapisan kedua
                ),
              ),
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 140,
                  color: Colors.blue, // Warna lapisan ketiga
                ),
              ),
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    isEditing ? 'Edit Catatan Minum' : 'Tambah Catatan Minum',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 8,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),

          // Konten
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Jumlah Air (ml)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${_amount.toInt()} ml',
                    style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                  ),
                  Slider(
                    min: 50,
                    max: 1000,
                    divisions: 19,
                    value: _amount,
                    label: _amount.toInt().toString(),
                    activeColor: Colors.blueAccent,
                    onChanged: (value) => setState(() => _amount = value),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Waktu Minum',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _pickTime,
                        icon: Icon(Icons.access_time),
                        label: Text('Pilih Waktu'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'amount': _amount,
                        'time': _selectedTime,
                      });
                    },
                    child: Text(isEditing ? 'Simpan Perubahan' : 'Simpan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
