import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _loginSessionKey = 'loggedInUser';
  static const String _favoritesKey = 'favoriteAnimeIds';

  // Menyimpan Session Login (ketika berhasil Login)
  static Future<void> saveLoginSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loginSessionKey, username);
  }

  // Mendapatkan Username (untuk Halaman Profile)
  static Future<String?> getLoggedInUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loginSessionKey);
  }

  // Menghapus Session Login (ketika Logout)
  static Future<void> clearLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginSessionKey);
  }

  // --- Favorites Management ---
  
  // Mengambil daftar ID anime favorit
  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // Menyimpan ID dalam bentuk Set<String> atau List<String>
    return prefs.getStringList(_favoritesKey) ?? [];
  }
  
  // Menambah/Menghapus ID anime dari daftar favorit
  static Future<void> toggleFavorite(String malId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = await getFavorites();
    
    if (favorites.contains(malId)) {
      favorites.remove(malId); // Hapus jika sudah ada
    } else {
      favorites.add(malId); // Tambah jika belum ada
    }
    
    await prefs.setStringList(_favoritesKey, favorites);
  }
}