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
        
        // Pastikan Anda memanggil map untuk mengonversi data ke model
        return animeData.map((json) => Anime.fromJson(json)).toList();
      } else {
        // Melempar DioException jika status code non-200
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to load top anime: Status ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      // Menangani error dari Dio (timeout, network issues)
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      // Menangani error umum lainnya (misalnya, parsing JSON gagal)
      throw Exception('Failed to process anime data: $e');
    }
  }
}