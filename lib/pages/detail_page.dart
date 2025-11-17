import 'package:flutter/material.dart';
import '../models/anime_model.dart';
import '../services/shared_prefs_service.dart';

class DetailPage extends StatefulWidget {
  final Anime anime;
  const DetailPage({super.key, required this.anime});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final favorites = await SharedPrefsService.getFavorites();
    setState(() {
      isFavorite = favorites.contains(widget.anime.malId.toString());
    });
  }

  void _toggleFavorite() async {
    await SharedPrefsService.toggleFavorite(widget.anime.malId.toString());
    setState(() {
      isFavorite = !isFavorite;
    });
    // Opsional: Beri feedback ke user
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isFavorite ? '${widget.anime.title} added to favorites.' : '${widget.anime.title} removed from favorites.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final anime = widget.anime;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(anime.title, style: const TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Icon Back
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey, // Berubah warna ketika diklik
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                anime.imageUrl,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 100),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              anime.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Score: ${anime.score}',
              style: const TextStyle(fontSize: 18, color: Colors.amber, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const Text(
              'Synopsis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text(
              anime.synopsis,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}