import 'package:flutter/material.dart';
import '../models/anime_model.dart';
import '../services/api_service.dart';
import '../services/shared_prefs_service.dart';
import 'detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final ApiService _apiService = ApiService();
  Future<List<Anime>>? _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Reload data ketika halaman aktif (misalnya setelah kembali dari DetailPage)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    // Kita harus mengambil semua top anime dulu, lalu memfilter yang favorit
    // Alternatif: Memanggil Jikan API untuk detail setiap MAL ID favorit (lebih efisien API call)
    final allAnime = await _apiService.fetchTopAnime();
    final favoriteIds = await SharedPrefsService.getFavorites();
    
    final favoriteAnime = allAnime.where((anime) {
      return favoriteIds.contains(anime.malId.toString());
    }).toList();

    setState(() {
      _favoritesFuture = Future.value(favoriteAnime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Anime>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading favorites: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('You have no favorite anime.'));
          }
          
          final List<Anime> favoriteList = snapshot.data!;
          
          return ListView.builder(
            itemCount: favoriteList.length,
            itemBuilder: (context, index) {
              final anime = favoriteList[index];
              return ListTile(
                leading: Image.network(
                  anime.imageUrl,
                  width: 50,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                ),
                title: Text(anime.title),
                subtitle: Text('Score: ${anime.score}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(anime: anime),
                    ),
                  ).then((_) => _loadFavorites()); // Refresh list saat kembali
                },
              );
            },
          );
        },
      ),
    );
  }
}