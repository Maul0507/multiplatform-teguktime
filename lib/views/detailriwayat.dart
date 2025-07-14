import 'package:flutter/material.dart';
import 'wave_clipper.dart';

class DetailRiwayatScreen extends StatelessWidget {
  final Map<String, dynamic> riwayat;

  DetailRiwayatScreen({required this.riwayat});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> jadwal = riwayat['schedules'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header bergelombang
          Stack(
            children: [
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 200,
                  color: Color(0xFF209CEE),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Detail Riwayat",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Box informasi utama
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hasil Catatan Intensitas Aktivitas Harian Anda",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                _buildDetailRow("Jenis Kelamin", riwayat['jenis_kelamin'] ?? 'N/A'),
                _buildDetailRow("Umur", '${riwayat['umur'] ?? 'N/A'} tahun'),
                _buildDetailRow("Berat Badan", '${riwayat['berat_badan'] ?? 'N/A'} kg'),
                _buildDetailRow("Tinggi Badan", '${riwayat['tinggi_badan'] ?? 'N/A'} cm'),
                _buildDetailRow("Intensitas", riwayat['aktivitas'] ?? 'N/A'),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Color(0xFF6DC5F4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Target Harian Anda:",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${riwayat['target_air'] ?? 0} ml/",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text("Hari", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Jadwal Minum Harian
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Jadwal minum anda:", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: jadwal.length,
                      itemBuilder: (context, index) {
                        final item = jadwal[index];
                        final waktu = item['schedule_time'] ?? '-';
                        final jumlah = item['volume_ml']?.toString() ?? '0';

                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Color(0xFFBEE6FD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xFF6DC5F4),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Icon(Icons.local_drink, color: Colors.white, size: 28),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('$jumlah ml',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        )),
                                    Text('Waktu: $waktu',
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                              Text(waktu,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                        );
                      },
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(": $value"),
        ],
      ),
    );
  }
}
