// lib/models/anime_model.dart
class Anime {
  final int malId;
  final String title;
  final String imageUrl;
  final double score;
  final String synopsis;
  final String status;
  final String trailerUrl;

  Anime({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.score,
    required this.synopsis,
    required this.status,
    required this.trailerUrl,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      malId: (json['mal_id'] ?? 0) as int,
      title: (json['title'] ?? '') as String,
      imageUrl: (json['images']?['jpg']?['image_url'] ??
              (json['image_url'] ?? '')) as String,
      score: (json['score'] is num) ? (json['score'] as num).toDouble() : 0.0,
      synopsis: (json['synopsis'] ?? '') as String,
      status: (json['status'] ?? '') as String,
      trailerUrl: (json['trailer']?['url'] ?? '') as String,
    );
  }
}
