// lib/services/session_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _loggedKey = 'loggedInUser';
  static const String _profilePhoto = 'profilePhotoBase64';
  static const String _nimKey = 'userNim';

  Future<void> saveLoggedUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loggedKey, username);
  }

  Future<String?> getLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loggedKey);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedKey);
  }

  Future<void> saveProfilePhoto(String base64) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profilePhoto, base64);
  }

  Future<String?> getProfilePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profilePhoto);
  }

  Future<void> saveNim(String nim) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nimKey, nim);
  }

  Future<String?> getNim() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nimKey);
  }
}
