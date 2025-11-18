// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anime_provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/anime_card.dart';
import 'detail_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AnimeProvider _animeProvider;

  @override
  void initState() {
    super.initState();
    _animeProvider = Provider.of<AnimeProvider>(context, listen: false);
    _animeProvider.loadTopAnime();
  }

  Future<void> _refresh() async {
    await _animeProvider.loadTopAnime();
  }

  @override
  Widget build(BuildContext context) {
    final animeProv = Provider.of<AnimeProvider>(context);
    final favProv = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Anime'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FavoritesPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Builder(builder: (_) {
          if (animeProv.loading) {
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemCount: 6,
              itemBuilder: (_, __) => const Center(child: CircularProgressIndicator()),
            );
          }

          if (animeProv.error != null) {
            return ListView(
              children: [Center(child: Text('Error: ${animeProv.error}'))],
            );
          }

          final list = animeProv.animes;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemCount: list.length,
            itemBuilder: (ctx, idx) {
              final a = list[idx];
              return AnimeCard(
                anime: a,
                isFav: favProv.isFavorite(a.malId),
                onFavToggle: () => favProv.toggleFavorite(a.malId),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailPage(anime: a)));
                },
              );
            },
          );
        }),
      ),
    );
  }
}
