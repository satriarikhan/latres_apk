// lib/models/user_model.dart
class UserModel {
  final String username;
  final String password;
  String? nim;
  String? photoBase64; // optional, can store base64 string

  UserModel({
    required this.username,
    required this.password,
    this.nim,
    this.photoBase64,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'nim': nim,
      'photoBase64': photoBase64,
    };
  }

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      nim: map['nim'],
      photoBase64: map['photoBase64'],
    );
  }
}
