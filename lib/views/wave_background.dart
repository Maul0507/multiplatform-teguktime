import 'package:flutter/material.dart';
import 'wave_clipper.dart'; // Pastikan WaveClipper ada di file ini.

class WaveBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: 220,
            color: Colors.lightBlue[100], // Warna gelombang pertama
          ),
        ),
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: 200,
            color: Colors.lightBlue[300], // Warna gelombang kedua
          ),
        ),
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: 180,
            color: Colors.blue, // Warna gelombang ketiga
          ),
        ),
      ],
    );
  }
}
