// lib/services/hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class HiveService {
  static Box get usersBox => Hive.box('users');
  static Box get favoritesBox => Hive.box('favorites');

  // Register user (username unique)
  Future<bool> register(UserModel user) async {
    final box = usersBox;
    if (box.containsKey(user.username)) return false;
    await box.put(user.username, user.toMap());
    return true;
  }

  UserModel? getUser(String username) {
    final box = usersBox;
    final map = box.get(username);
    if (map == null) return null;
    return UserModel.fromMap(Map<dynamic, dynamic>.from(map));
  }

  Future<void> saveUser(UserModel user) async {
    final box = usersBox;
    await box.put(user.username, user.toMap());
  }

  // favorites stored as list of malId ints
  List<int> getFavorites() {
    final box = favoritesBox;
    final list = box.get('favorites_list', defaultValue: <int>[]);
    return List<int>.from(list);
  }

  Future<void> saveFavorites(List<int> ids) async {
    final box = favoritesBox;
    await box.put('favorites_list', ids);
  }
}
