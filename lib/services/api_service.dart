import 'package:dio/dio.dart';
import '../models/anime_model.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.jikan.moe/v4';

  Future<List<Anime>> fetchTopAnime() async {
    try {
      final response = await _dio.get('$_baseUrl/top/anime');
      if (response.statusCode == 200) {
        // Data anime berada di bawah kunci 'data'
        final List<dynamic> animeData = response.data['data'];
        return animeData.map((json) => Anime.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load top anime: Status ${response.statusCode}');
      }
    } catch (e) {
      // Menangani error Dio (timeout, network issues, dll.)
      throw Exception('Failed to fetch top anime: $e');
    }
  }
}