import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/intensitas_provider.dart';
import '../models/intensitas_model.dart';
import 'detailriwayat.dart';
import 'wave_clipper.dart';

class RiwayatScreen extends StatefulWidget {
  @override
  _RiwayatScreenState createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  @override
  void initState() {
    super.initState();
    // Ambil data saat pertama kali dibuka
    Future.microtask(() {
      final provider = Provider.of<IntensitasProvider>(context, listen: false);
      provider.fetchIntensitasList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Consumer<IntensitasProvider>(
              builder: (context, provider, _) {
                final riwayatList = provider.list;

                if (riwayatList.isEmpty) {
                  return Center(child: Text('Belum ada riwayat'));
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: riwayatList.length,
                  itemBuilder: (context, index) {
                    final riwayat = riwayatList[index];

                    return GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => DetailRiwayatScreen(data: riwayat),
                        //   ),
                        // );
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
                              child: Icon(Icons.local_drink, size: 32, color: Colors.white),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kebutuhan Air: ${riwayat.targetAir} ml',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Aktivitas: ${riwayat.aktivitas}',
                                    style: TextStyle(fontSize: 13, color: Colors.black54),
                                  ),
                                  Text(
                                    'Tanggal: ${riwayat.tanggal}',
                                    style: TextStyle(fontSize: 13, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            // IconButton(
                            //   icon: Icon(Icons.delete, color: Colors.red),
                            //   onPressed: () {
                            //     provider.deleteRiwayatById(riwayat.id);
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
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
        ClipPath(clipper: WaveClipper(), child: Container(height: 200, color: Colors.lightBlue[100])),
        ClipPath(clipper: WaveClipper(), child: Container(height: 180, color: Colors.lightBlue[300])),
        ClipPath(clipper: WaveClipper(), child: Container(height: 160, color: Colors.blue)),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Riwayat',
              style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
