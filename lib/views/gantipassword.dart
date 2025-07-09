// import 'package:flutter/material.dart';
// import 'package:teguk_time/views/intensitas_screen.dart';
// import 'package:teguk_time/views/wave_clipper.dart' hide WaveClipper; // Import WaveClipper

// class ChangePasswordScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 66, 168, 252),
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           "Ganti Password",
//           style: TextStyle(color: Colors.white, fontSize: 20),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Header gelombang dengan tumpukan
//           Stack(
//             children: [
//               ClipPath(
//                 clipper: WaveClipper(),
//                 child: Container(
//                   height: 180,
//                   color: Colors.lightBlue[100], // Warna lapisan pertama
//                 ),
//               ),
//               ClipPath(
//                 clipper: WaveClipper(),
//                 child: Container(
//                   height: 160,
//                   color: Colors.lightBlue[300], // Warna lapisan kedua
//                 ),
//               ),
//               ClipPath(
//                 clipper: WaveClipper(),
//                 child: Container(
//                   height: 140,
//                   color: Colors.blue, // Warna lapisan ketiga
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Card(
//               elevation: 5,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Text(
//                         "Ganti Password",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Password :",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         Expanded(
//                           child: TextField(
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               hintText: '********',
//                             ),
//                             obscureText: true,
//                             textAlign: TextAlign.right,
//                           ),
//                         ),
//                         Icon(Icons.visibility, color: Colors.grey),
//                       ],
//                     ),
//                     Divider(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Ulangi Password :",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         Expanded(
//                           child: TextField(
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               hintText: '********',
//                             ),
//                             obscureText: true,
//                             textAlign: TextAlign.right,
//                           ),
//                         ),
//                         Icon(Icons.visibility, color: Colors.grey),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Center(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           "Simpan",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue[700],
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 40, vertical: 10),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
