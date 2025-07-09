import 'package:flutter/material.dart';
import 'detailriwayat.dart'; // Ganti dengan nama file detail jika berbeda
import 'wave_clipper.dart'; // Pastikan file clipper ini ada

class RiwayatScreen extends StatefulWidget {
  @override
  _RiwayatScreenState createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  List<Map<String, String>> riwayatList = [
    {
      'tanggal': '10 Juni 2025',
      'kebutuhan': '2100 ml',
      'jadwal': '8 Kali Minum',
      'progress': '7/8 Tercapai',
    },
    {
      'tanggal': '9 Juni 2025',
      'kebutuhan': '2100 ml',
      'jadwal': '8 Kali Minum',
      'progress': '6/8 Tercapai',
    },
    {
      'tanggal': '8 Juni 2025',
      'kebutuhan': '2000 ml',
      'jadwal': '7 Kali Minum',
      'progress': '5/7 Tercapai',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: riwayatList.length,
              itemBuilder: (context, index) {
                final riwayat = riwayatList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailRiwayatScreen(
                          riwayat: riwayat,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFFE6F2FA),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.lightBlue[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.local_drink,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kebutuhan Air ${riwayat['kebutuhan']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue[800],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Jadwal tersimpan: ${riwayat['jadwal']}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Progress Minum: ${riwayat['progress']}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                riwayat['tanggal'] ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              riwayatList.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipper(),
          child: Container(height: 200, color: Colors.lightBlue[100]),
        ),
        ClipPath(
          clipper: WaveClipper(),
          child: Container(height: 180, color: Colors.lightBlue[300]),
        ),
        ClipPath(
          clipper: WaveClipper(),
          child: Container(height: 160, color: Colors.blue),
        ),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Riwayat',
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
