// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/hive_service.dart';
import '../services/session_service.dart';

class AuthProvider with ChangeNotifier {
  final HiveService _hive = HiveService();
  final SessionService _session = SessionService();

  UserModel? currentUser;

  Future<bool> register(String username, String password) async {
    final user = UserModel(username: username, password: password);
    final ok = await _hive.register(user);
    return ok;
  }

  Future<bool> login(String username, String password) async {
    final user = _hive.getUser(username);
    if (user == null) return false;
    if (user.password != password) return false;
    currentUser = user;
    await _session.saveLoggedUser(username);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    currentUser = null;
    await _session.clearSession();
    notifyListeners();
  }

  // load current user from session
  Future<void> loadFromSession() async {
    final username = await _session.getLoggedUser();
    if (username != null) {
      currentUser = _hive.getUser(username);
      notifyListeners();
    }
  }

  Future<void> updateProfile(String username, {String? nim, String? photoBase64}) async {
    final user = _hive.getUser(username);
    if (user == null) return;
    user.nim = nim ?? user.nim;
    user.photoBase64 = photoBase64 ?? user.photoBase64;
    await _hive.saveUser(user);
    currentUser = user;
    notifyListeners();
  }
}
