import 'package:hive_flutter/hive_flutter.dart';
// import '../models/user_model.dart'; // Asumsikan Anda punya UserModel

class HiveService {
  static const String _userBoxName = 'userBox';
  
  // Inisialisasi Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    // Hive.registerAdapter(UserAdapter()); // Daftarkan adapter user
    await Hive.openBox<Map<dynamic, dynamic>>(_userBoxName);
  }

  // Menyimpan data user (Register)
  Future<void> registerUser(String username, String password) async {
    final box = Hive.box<Map<dynamic, dynamic>>(_userBoxName);
    // Simpan data dalam bentuk Map
    await box.put(username, {'username': username, 'password': password});
  }

  // Memverifikasi data user (Login)
  Future<bool> verifyUser(String username, String password) async {
    final box = Hive.box<Map<dynamic, dynamic>>(_userBoxName);
    final userData = box.get(username);
    if (userData != null && userData['password'] == password) {
      return true; // Login berhasil
    }
    return false; // Login gagal
  }
}