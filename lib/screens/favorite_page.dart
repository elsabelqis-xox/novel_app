import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favorite_model.dart';
import '../models/bookshelf_model.dart'; // Diperlukan karena ada interaksi dengan BookshelfModel
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buku Favorit Saya❤️')),
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
                                // PASTIKAN SEMUA PARAMETER INI SESUAI DENGAN DEFINISI DI DETAIL_PAGE.DART
                                // title dan author adalah required dan harus non-null
                                title:
                                    book['title'] ??
                                    'Judul Tidak Diketahui', // Tambahkan ?? jika ini bisa null
                                author:
                                    book['author'] ??
                                    'Penulis Tidak Diketahui', // Tambahkan ?? jika ini bisa null
                                // description, imageUrl, olid, openLibraryUrl adalah String? (nullable) di DetailPage
                                // Jadi, cukup panggil langsung tanpa '!' di sini
                                description: book['description'], // Hapus '!'
                                imageUrl:
                                    book['imageUrl'], // PERBAIKAN: Gunakan 'imageUrl' (camelCase), Hapus '!'
                                olid: book['olid'],
                                openLibraryUrl:
                                    book['openLibraryUrl'], // Hapus '!'
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
                              // PERBAIKAN: Gunakan 'imageUrl' (camelCase) dan tambahkan fallback
                              book['imageUrl'] ??
                                  'https://via.placeholder.com/70x100?text=No+Image',
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
                                  book['title'] ??
                                      'Judul Tidak Diketahui', // Tambahkan ?? jika ini bisa null
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  book['author'] ??
                                      'Penulis Tidak Diketahui', // Tambahkan ?? jika ini bisa null
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                // Menggunakan Consumer2 karena berinteraksi dengan dua model: Bookshelf dan Favorite
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
                                        .isFavorite(
                                          book,
                                        ); // Pastikan ini juga dicek
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
                                                    '${book['title'] ?? 'Buku'} dihapus dari Rak Buku.',
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
                                                    '${book['title'] ?? 'Buku'} disimpan ke Rak Buku.',
                                                  ),
                                                ),
                                              );
                                            }
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
