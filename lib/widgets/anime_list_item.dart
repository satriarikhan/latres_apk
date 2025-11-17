import 'package:flutter/material.dart';
import '../models/anime_model.dart';
import '../pages/detail_page.dart';

class AnimeListItem extends StatelessWidget {
  final Anime anime;

  const AnimeListItem({
    super.key,
    required this.anime,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        anime.imageUrl,
        width: 50,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.image_not_supported),
      ),
      title: Text(anime.title),
      subtitle: Text('Score: ${anime.score}'),
      onTap: () {
        // Arahkan ke Halaman Detail
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(anime: anime),
          ),
        );
      },
    );
  }
}