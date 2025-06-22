import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bookshelf_model.dart';
import '../models/favorite_model.dart'; // Penting: Pastikan ini diimport
import 'detail_page.dart';

class BookshelfPage extends StatelessWidget {
  const BookshelfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rak Buku Saya📚'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Consumer<BookshelfModel>(
        builder: (context, bookshelfModel, child) {
          if (bookshelfModel.bookshelf.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Rak bukumu masih kosong. Yuk, tambahkan buku dari halaman Beranda atau Cari!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookshelfModel.bookshelf.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> book =
                    bookshelfModel.bookshelf[index];

                // Akses nilai dengan aman dan teruskan ke DetailPage
                // Karena DetailPage sudah menerima String?, kita bisa langsung meneruskannya.
                final String title =
                    book['title']?.toString() ?? 'Judul Tidak Diketahui';
                final String author =
                    book['author']?.toString() ?? 'Penulis Tidak Diketahui';
                // description, imageUrl, olid, openLibraryUrl bisa null, jadi tidak perlu default value di sini
                // Cukup biarkan null jika memang null dari data `book`.
                final String? description = book['description']?.toString();
                final String? imageUrl = book['imageUrl']?.toString();
                final String? olid = book['olid']?.toString();
                final String? openLibraryUrl =
                    book['openLibraryUrl']?.toString();

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
                                title: title,
                                author: author,
                                description:
                                    description, // Meneruskan null jika description memang null
                                imageUrl:
                                    imageUrl, // Meneruskan null jika imageUrl memang null
                                olid:
                                    olid, // Meneruskan null jika olid memang null
                                openLibraryUrl:
                                    openLibraryUrl, // Meneruskan null jika openLibraryUrl memang null
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
                              imageUrl ??
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
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.surfaceVariant,
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
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.surfaceVariant,
                                  child: Icon(
                                    Icons.book,
                                    size: 50,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
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
                                  title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  author,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
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
                                        // Tombol Bookmark (Rak Buku) - Hanya untuk menghapus
                                        IconButton(
                                          icon: Icon(
                                            Icons
                                                .bookmark, // Selalu bookmark terisi karena sudah di rak buku
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                          ),
                                          onPressed: () {
                                            // Langsung hapus karena tombol ini hanya muncul jika buku ada di rak
                                            bookshelfModel.removeBook(book);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.bookmark_remove,
                                                      color:
                                                          Theme.of(
                                                            context,
                                                          ).colorScheme.onError,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        '$title dihapus dari Rak Buku.',
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onError,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                backgroundColor:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.error,
                                                duration: const Duration(
                                                  seconds: 2,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        // Tombol Favorit
                                        IconButton(
                                          icon: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                isFavorite
                                                    ? Colors.red
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                          ),
                                          onPressed: () {
                                            favoriteModel.toggleFavorite(book);
                                            final String message;
                                            final Color iconColor;
                                            final IconData iconData;
                                            final Color backgroundColor;

                                            if (isFavorite) {
                                              message =
                                                  '$title dihapus dari Favorit.';
                                              iconData = Icons.favorite_border;
                                              iconColor =
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onError;
                                              backgroundColor =
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.error;
                                            } else {
                                              message =
                                                  '$title ditambahkan ke Favorit.';
                                              iconData = Icons.favorite;
                                              iconColor =
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onPrimary;
                                              backgroundColor =
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary;
                                            }

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Row(
                                                  children: [
                                                    Icon(
                                                      iconData,
                                                      color: iconColor,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        message,
                                                        style: TextStyle(
                                                          color: iconColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                backgroundColor:
                                                    backgroundColor,
                                                duration: const Duration(
                                                  seconds: 2,
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
