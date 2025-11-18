import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/auth_provider.dart';
import 'providers/anime_provider.dart';
import 'providers/favorite_provider.dart';

import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('users');       // untuk akun user
  await Hive.openBox('favorites');   // untuk daftar favorit

  // Run App
  runApp(const AnimeApp());
}

class AnimeApp extends StatefulWidget {
  const AnimeApp({super.key});

  @override
  State<AnimeApp> createState() => _AnimeAppState();
}

class _AnimeAppState extends State<AnimeApp> {
  String? _loggedUsername;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  // Cek SharedPreferences apakah user pernah login
  Future<void> _checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString('loggedInUser');

    setState(() {
      _loggedUsername = savedUser;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AnimeProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Anime App",
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFF6B00),      // orange crunchyroll
            secondary: Color(0xFFFF8C32),
          ),
          fontFamily: "Poppins",
        ),

        // Jika sudah login → ke HomePage
        // Jika belum login → ke LoginPage
        home: _loggedUsername == null ? const LoginPage() : const HomePage(),
      ),
    );
  }
}
