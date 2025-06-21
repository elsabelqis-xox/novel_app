import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favorite_model.dart';
import '../models/bookshelf_model.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buku Favorit Saya')),
      body: Consumer<FavoriteModel>(
        builder: (context, favoriteModel, child) {
          if (favoriteModel.favoriteNovels.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada buku favorit. Tambahkan favorit dari halaman Beranda atau Cari!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteModel.favoriteNovels.length,
              itemBuilder: (context, index) {
                final book = favoriteModel.favoriteNovels[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DetailPage(
                                title: book['title']!,
                                author: book['author']!,
                                description: book['description']!,
                                imageurl: book['image']!,
                                olid: book['olid'],
                              ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              book['image']!,
                              height: 100,
                              width: 70,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    height: 100,
                                    width: 70,
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book['title']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  book['author']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Consumer2<BookshelfModel, FavoriteModel>(
                                  builder: (
                                    context,
                                    bookshelfModel,
                                    favoriteModel,
                                    child,
                                  ) {
                                    final bool isInBookshelf = bookshelfModel
                                        .isInBookshelf(book);
                                    final bool isFavorite = favoriteModel
                                        .isFavorite(book);
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            isInBookshelf
                                                ? Icons.bookmark
                                                : Icons.bookmark_border,
                                            color:
                                                isInBookshelf
                                                    ? Theme.of(
                                                      context,
                                                    ).colorScheme.primary
                                                    : Colors.grey,
                                          ),
                                          onPressed: () {
                                            if (isInBookshelf) {
                                              bookshelfModel.removeBook(book);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '${book['title']} dihapus dari Rak Buku.',
                                                  ),
                                                ),
                                              );
                                            } else {
                                              bookshelfModel.addBook(book);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '${book['title']} disimpan ke Rak Buku.',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),

                                        IconButton(
                                          icon: const Icon(Icons.favorite),
                                          color: Colors.red,
                                          onPressed: () {
                                            favoriteModel.toggleFavorite(book);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '${book['title']} dihapus dari Favorit.',
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
