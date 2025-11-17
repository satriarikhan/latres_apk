class User {
  final String username;
  final String password;
  // Anda bisa menambahkan field lain seperti name, nim, dll.

  User({
    required this.username,
    required this.password,
  });

  // Metode toMap untuk menyimpan ke Hive/Map
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }
}