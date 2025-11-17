import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Untuk kDebugMode
import 'package:latres_apk/pages/home_page.dart';
import 'package:latres_apk/pages/login_page.dart';
import 'package:latres_apk/pages/register_page.dart';
import 'package:latres_apk/services/hive_service.dart';
import 'package:latres_apk/services/shared_prefs_service.dart';
import 'package:provider/provider.dart';

// Widget untuk menampilkan error secara visual (hanya di Debug/Profile)
Widget _errorWidget(FlutterErrorDetails details) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Kesalahan Aplikasi Fatal'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning, color: Colors.red, size: 50),
              const SizedBox(height: 10),
              const Text(
                'Terjadi Kesalahan yang Tidak Tertangani.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Detail Error untuk Debugging
              Text(
                'Error: ${details.exception}\nStack: ${details.stack}',
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // --- Global Error Handler (Pencegah White Screen) ---
  ErrorWidget.builder = (details) {
    if (kDebugMode || kProfileMode) {
      return _errorWidget(details);
    }
    // Mode Release: tampilkan pesan sederhana
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text("Aplikasi mengalami kesalahan. Mohon coba lagi."))),
    );
  };
  // ----------------------------------------------------
  
  // Inisialisasi Hive (jika gagal, error akan ditangkap oleh ErrorWidget.builder)
  await HiveService.init(); 
  
  runApp(
    MultiProvider(
      providers: const [
        // Tambahkan providers (Auth, Favorites state) di sini jika menggunakan State Management
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyAnimeArchive',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // FutureBuilder untuk menentukan halaman awal (Login atau Home)
      home: FutureBuilder<String?>(
        future: SharedPrefsService.getLoggedInUsername(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          final String? username = snapshot.data;
          if (username != null) {
            // Jika ada sesi, langsung ke HomePage
            return const MainNavigationScreen(initialIndex: 0);
          } else {
            // Jika tidak ada sesi, ke LoginPage
            return LoginPage();
          }
        },
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => const MainNavigationScreen(initialIndex: 0),
      },
    );
  }
}