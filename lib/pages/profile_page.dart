import 'package:flutter/material.dart';
import '../services/shared_prefs_service.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = 'Loading...';
  
  // Data statis untuk contoh (sesuai ketentuan soal)
  final String _name = 'Gwejh (Contoh Nama)';
  final String _nim = '123220000 (Contoh NIM)';
  
  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final username = await SharedPrefsService.getLoggedInUsername();
    setState(() {
      _username = username ?? 'N/A';
    });
  }

  void _handleLogout(BuildContext context) async {
    // Hapus session login
    await SharedPrefsService.clearLoginSession();
    
    // Arahkan kembali ke halaman Login dan hapus semua rute sebelumnya
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 60, color: Colors.white), 
              // Di sini tempat untuk fitur opsional: foto dari kamera
            ),
            const SizedBox(height: 20),
            Text(
              _name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              _nim,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Logged in as: $_username', // Wajib ambil dari database/session
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}