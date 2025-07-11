import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teguk_time/views/edit_profile_screen.dart';
import 'package:teguk_time/views/gantipassword.dart';
import 'package:teguk_time/views/wave_clipper.dart';
import '../providers/user_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 38, 149, 240),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: WaveClipper(),
                child: Container(height: 180, color: Colors.lightBlue[100]),
              ),
              ClipPath(
                clipper: WaveClipper(),
                child: Container(height: 160, color: Colors.lightBlue[300]),
              ),
              ClipPath(
                clipper: WaveClipper(),
                child: Container(height: 140, color: Colors.blue),
              ),
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "Profil",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      user?.name ?? 'Nama Tidak Ditemukan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      user?.email ?? 'Email Tidak Ditemukan',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    Divider(height: 30, thickness: 1),
                    ListTile(
                      leading: Icon(Icons.edit, color: Colors.black),
                      title: Text("Edit profil"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    // Ganti Password (opsional aktifkan jika siap)
                    // ListTile(
                    //   leading: Icon(Icons.lock, color: Colors.black),
                    //   title: Text("Ganti password"),
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
                    //     );
                    //   },
                    // ),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text(
                        "Logout",
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Konfirmasi Logout"),
                            content: Text("Apakah Anda yakin ingin logout?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text("Logout"),
                              ),
                            ],
                          ),
                        );
// ini
                        if (confirm == true) {
                          await Provider.of<UserProvider>(
                            context,
                            listen: false,
                          ).logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
