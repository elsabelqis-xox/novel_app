import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bookshelf_model.dart';
import '../models/favorite_model.dart';
import 'detail_page.dart';

class BookshelfPage extends StatelessWidget {
  const BookshelfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rak Buku Saya🛒'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Consumer<BookshelfModel>(
        builder: (context, bookshelfModel, child) {
          if (bookshelfModel.bookshelf.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Rak bukumu masih kosong. Yuk, tambahkan buku dari halaman Beranda atau Cari!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookshelfModel.bookshelf.length,
              itemBuilder: (context, index) {
                final book = bookshelfModel.bookshelf[index];
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
                                title: book['title'] ?? 'Judul Tidak Diketahui',
                                author:
                                    book['author'] ?? 'Penulis Tidak Diketahui',
                                description: book['description'],
                                imageUrl: book['imageUrl'],
                                olid: book['olid'],
                                openLibraryUrl: book['openLibraryUrl'],
                              ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              book['imageUrl'] ??
                                  'https://via.placeholder.com/70x100?text=No+Image',
                              height: 100,
                              width: 70,
                              fit: BoxFit.cover,

                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 100,
                                  width: 70,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                );
                              },

                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 100,
                                  width: 70,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.book,
                                    size: 50,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book['title'] ?? 'Judul Tidak Diketahui',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  book['author'] ?? 'Penulis Tidak Diketahui',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Consumer<FavoriteModel>(
                                  builder: (context, favoriteModel, child) {
                                    final bool isFavorite = favoriteModel
                                        .isFavorite(book);
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.bookmark_remove,
                                          ),
                                          color: Colors.red,
                                          onPressed: () {
                                            bookshelfModel.removeBook(book);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '${book['title'] ?? 'Buku'} dihapus dari Rak Buku.',
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                isFavorite
                                                    ? Colors.red
                                                    : Colors.grey,
                                          ),
                                          onPressed: () {
                                            favoriteModel.toggleFavorite(book);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  isFavorite
                                                      ? '${book['title'] ?? 'Buku'} dihapus dari Favorit.'
                                                      : '${book['title'] ?? 'Buku'} ditambahkan ke Favorit.',
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
