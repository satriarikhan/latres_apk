class Anime {
  final int malId;
  final String title;
  final String imageUrl;
  final double score;
  final String synopsis;

  Anime({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.score,
    required this.synopsis,
  });

  // Factory constructor untuk membuat objek Anime dari JSON
  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      malId: json['mal_id'] ?? 0,
      title: json['title'] ?? 'No Title',
      // Mengambil URL dari 'images' -> 'jpg'
      imageUrl: json['images']?['jpg']?['image_url'] ?? '',
      // Score bisa berupa int atau double, pastikan diubah ke double
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      synopsis: json['synopsis'] ?? 'No synopsis available.',
    );
  }
}