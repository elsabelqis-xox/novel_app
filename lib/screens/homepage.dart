import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:novel_app/screens/detail_page.dart';
import 'bookshelf_page.dart';
import '../models/bookshelf_model.dart';
import '../models/theme_provider.dart';
import 'package:novel_app/screens/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';

  final List<Map<String, String>> _allNovels = [
    {
      'title': 'Langit yang Tak Sama',
      'author': 'Ayu Lestari',
      'description': 'Kisah cinta dua dunia yang tak pernah saling mengerti.',
      'image':
          'https://images.unsplash.com/photo-1606112219348-204d7d8b94ee?auto=format&fit=crop&w=500&q=80',
    },
    {
      'title': 'Hujan di Ujung Senja',
      'author': 'Rizky Fajar',
      'description': 'Puisi kehidupan dan kehilangan yang abadi.',
      'image':
          'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=500&q=80',
    },
    {
      'title': 'Rembulan di Balik Awan',
      'author': 'Dewi Anggraini',
      'description': 'Perjalanan panjang mencari makna hidup.',
      'image':
          'https://images.unsplash.com/photo-1507842217343-583bb7270b66?auto=format&fit=crop&w=500&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredNovels =
        _allNovels.where((novel) {
          final title = novel['title']!.toLowerCase();
          final author = novel['author']!.toLowerCase();
          final keyword = _searchKeyword.toLowerCase();
          return title.contains(keyword) || author.contains(keyword);
        }).toList();

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 NovelKu'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari judul atau penulis...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredNovels.length,
              itemBuilder: (context, index) {
                final novel = filteredNovels[index];
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DetailPage(
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
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Cari Novel',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );
              },
            ),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return IconButton(
                  icon: Icon(
                    themeProvider.themeMode == ThemeMode.dark
                        ? Icons.wb_sunny_outlined
                        : Icons.dark_mode_outlined,
                  ),
                  tooltip: 'Ubah Tema',
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                );
              },
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Pengaturan',
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: badges.Badge(
        position: badges.BadgePosition.topEnd(top: -5, end: -5),
        badgeContent: Consumer<BookshelfModel>(
          builder: (context, bookshelfModel, child) {
            return Text(
              '${bookshelfModel.bookshelf.length}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            );
          },
        ),
        badgeStyle: const badges.BadgeStyle(badgeColor: Colors.redAccent),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          tooltip: 'Lihat Rak Buku',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookshelfPage()),
            );
          },
          child: const Icon(Icons.bookmark),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
