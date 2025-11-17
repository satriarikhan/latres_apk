import 'package:flutter/material.dart';
import 'package:latres_apk/pages/home_page.dart';
import 'package:latres_apk/pages/login_page.dart';
import 'package:latres_apk/pages/register_page.dart';
import 'package:latres_apk/services/hive_service.dart';
import 'package:latres_apk/services/shared_prefs_service.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init(); // Inisialisasi Hive
  // Tidak perlu inisialisasi SharedPrefs secara eksplisit, akan dilakukan saat dipanggil
  
  // Catatan: Anda perlu membuat Provider untuk State Management
  // Contoh Provider: AuthProvider, FavoritesProvider
  runApp(
    MultiProvider(
      providers: [
        // Tambahkan providers lain di sini (misalnya untuk Favorites, Auth state)
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