import 'package:flutter/material.dart';
import '../services/hive_service.dart';
import '../services/shared_prefs_service.dart';
import 'home_page.dart'; // Import MainNavigationScreen
import 'register_page.dart'; // Import RegisterPage

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final HiveService _hiveService = HiveService();

  LoginPage({super.key});

  void _handleLogin(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username and password are required.')),
        );
      }
      return;
    }

    final bool success = await _hiveService.verifyUser(username, password);

    if (context.mounted) {
      if (success) {
        // Simpan sesi login
        await SharedPrefsService.saveLoginSession(username);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome back, $username!')),
        );
        // Arahkan ke Halaman Utama (MainNavigationScreen)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainNavigationScreen(initialIndex: 0)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'MyAnimeArchive',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleLogin(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Arahkan ke halaman Register
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: const Text('Belum punya akun? Register.', style: TextStyle(color: Colors.deepPurple)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}