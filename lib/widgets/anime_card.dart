// lib/widgets/anime_card.dart
import 'package:flutter/material.dart';
import '../models/anime_model.dart';

class AnimeCard extends StatelessWidget {
  final Anime anime;
  final VoidCallback onTap;
  final VoidCallback onFavToggle;
  final bool isFav;

  const AnimeCard({super.key, required this.anime, required this.onTap, required this.onFavToggle, required this.isFav});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(anime.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey)),
                  Positioned(
                    top: 6, right: 6,
                    child: InkWell(
                      onTap: onFavToggle,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(30)),
                        child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(anime.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, size: 14),
              const SizedBox(width: 4),
              Text(anime.score.toString()),
            ],
          )
        ],
      ),
    );
  }
}
