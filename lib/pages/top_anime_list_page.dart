import 'package:flutter/material.dart';
import '../models/anime_model.dart';
import '../services/api_service.dart';
import 'detail_page.dart';

class TopAnimeListPage extends StatefulWidget {
  const TopAnimeListPage({super.key});

  @override
  State<TopAnimeListPage> createState() => _TopAnimeListPageState();
}

class _TopAnimeListPageState extends State<TopAnimeListPage> {
  late Future<List<Anime>> _topAnimeFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _topAnimeFuture = _apiService.fetchTopAnime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Anime'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Anime>>(
        future: _topAnimeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Menangani Error yang berasal dari ApiService
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, size: 50, color: Colors.grey),
                    const SizedBox(height: 10),
                    Text(
                      'Gagal memuat data: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _topAnimeFuture = _apiService
                              .fetchTopAnime(); // Coba muat ulang
                        });
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data anime ditemukan.'));
          }

          final List<Anime> animeList = snapshot.data!;

          // Menggunakan ListView (sesuai contoh tampilan)
          return ListView.builder(
            itemCount: animeList.length,
            itemBuilder: (context, index) {
              final anime = animeList[index];
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
            },
          );
        },
      ),
    );
  }
}
