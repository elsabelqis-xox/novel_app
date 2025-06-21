import 'package:flutter/material.dart';
import 'package:novel_app/screens/detail_page.dart';
import 'package:provider/provider.dart';
import 'package:novel_app/models/favorite_model.dart';

class HomeContentPage extends StatefulWidget {
  const HomeContentPage({super.key});

  @override
  State<HomeContentPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  final List<Map<String, String>> _popularNovels = const [
    {
      'key': 'novel_popular_001',
      'title': 'Langit yang Tak Sama (Populer)',
      'author': 'Ayu Lestari',
      'description': 'Kisah cinta dua dunia yang tak pernah saling mengerti.',
      'image':
          'https://images.unsplash.com/photo-1606112219348-204d7d8b94ee?auto=format&fit=crop&w=500&q=80',
    },
    {
      'key': 'novel_popular_002',
      'title': 'Hujan di Ujung Senja (Populer)',
      'author': 'Rizky Fajar',
      'description': 'Puisi kehidupan dan kehilangan yang abadi.',
      'image':
          'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=500&q=80',
    },
    {
      'key': 'novel_popular_003',
      'title': 'Rembulan di Balik Awan (Populer)',
      'author': 'Dewi Anggraini',
      'description': 'Perjalanan panjang mencari makna hidup.',
      'image':
          'https://images.unsplash.com/photo-1507842217343-583bb7270b66?auto=format&fit=crop&w=500&q=80',
    },
  ];

  final List<Map<String, String>> _latestNovels = const [
    {
      'key': 'novel_latest_001',
      'title': 'Novel Terbaru I',
      'author': 'Sinta Budi',
      'description': 'Petualangan seru di dunia fantasi yang menakjubkan.',
      'image':
          'https://images.unsplash.com/photo-1532012197247-f47feee5ee96?auto=format&fit=crop&w=500&q=80',
    },
    {
      'key': 'novel_latest_002',
      'title': 'Novel Terbaru II',
      'author': 'Andi Pratama',
      'description': 'Misteri yang harus dipecahkan di kota metropolitan.',
      'image':
          'https://images.unsplash.com/photo-1593345472152-b883c7b6c507?auto=format&fit=crop&w=500&q=80',
    },
    {
      'key': 'novel_latest_003',
      'title': 'Novel Terbaru III',
      'author': 'Citra Kirana',
      'description': 'Romansa klasik dengan sentuhan modern.',
      'image':
          'https://images.unsplash.com/photo-1549202534-733c37562f02?auto=format&fit=crop&w=500&q=80',
    },
  ];

  final List<Map<String, String>> _recommendedNovels = const [
    {
      'key': 'novel_recommended_001',
      'title': 'Penerbangan Malam',
      'author': 'Budi Santoso',
      'description': 'Fiksi ilmiah yang akan membawa Anda ke galaksi jauh.',
      'image':
          'https://images.unsplash.com/photo-1497633761757-5506041a7985?auto=format&fit=crop&w=500&q=80',
    },
    {
      'key': 'novel_recommended_002',
      'title': 'Lembah Rahasia',
      'author': 'Dian Permata',
      'description': 'Kisah petualangan dan penemuan diri di alam liar.',
      'image':
          'https://images.unsplash.com/photo-1629858763785-5b4813589c37?auto=format&fit=crop&w=500&q=80',
    },
    {
      'key': 'novel_recommended_003',
      'title': 'Antologi Senja',
      'author': 'Kumpulan Penulis',
      'description': 'Kumpulan cerita pendek yang menyentuh hati.',
      'image':
          'https://images.unsplash.com/photo-1558980394-fd9081e7d23a?auto=format&fit=crop&w=500&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Libera Book',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Populer'),
              Tab(text: 'Terbaru'),
              Tab(text: 'Rekomendasi'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: TabBarView(
          children: [
            _buildNovelList(_popularNovels),
            _buildNovelList(_latestNovels),
            _buildNovelList(_recommendedNovels),
          ],
        ),
      ),
    );
  }

  Widget _buildNovelList(List<Map<String, String>> novels) {
    if (novels.isEmpty) {
      return const Center(
        child: Text('Belum ada novel tersedia di kategori ini.'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: novels.length,
      itemBuilder: (context, index) {
        final novel = novels[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                novel['image']!,
                width: 60,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.book, size: 30, color: Colors.grey),
                  );
                },
              ),
            ),
            title: Text(
              novel['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(novel['author']!),
                const SizedBox(height: 4),
                Text(
                  novel['description']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: Consumer<FavoriteModel>(
              builder: (context, favoriteModel, child) {
                final bool isFav = favoriteModel.isFavorite(novel);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    favoriteModel.toggleFavorite(novel);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFav
                              ? '${novel['title']} dihapus dari favorit!'
                              : '${novel['title']} ditambahkan ke favorit!',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => DetailPage(
                        title: novel['title']!,
                        author: novel['author']!,
                        description: novel['description']!,
                        imageurl: novel['image']!,
                      ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
