// lib/pages/favorites_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/anime_provider.dart';
import '../widgets/anime_card.dart';
import 'detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final favProv = Provider.of<FavoriteProvider>(context);
    final animeProv = Provider.of<AnimeProvider>(context, listen: false);

    final favIds = favProv.favorites;
    // We'll map ids to Anime objects from currently loaded list if possible
    final all = animeProv.animes;
    final favAnimes = all.where((a) => favIds.contains(a.malId)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favAnimes.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemCount: favAnimes.length,
              itemBuilder: (ctx, idx) {
                final a = favAnimes[idx];
                return AnimeCard(
                  anime: a,
                  isFav: true,
                  onFavToggle: () => favProv.toggleFavorite(a.malId),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailPage(anime: a))),
                );
              },
            ),
    );
  }
}
