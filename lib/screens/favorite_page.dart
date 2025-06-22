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
      appBar: AppBar(
        title: const Text('Buku Favorit Saya❤️'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Consumer<FavoriteModel>(
        builder: (context, favoriteModel, child) {
          if (favoriteModel.favoriteNovels.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Belum ada buku favorit. Tambahkan favorit dari halaman Beranda atau Cari!',
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
                                title: book['title'] ?? 'Judul Tidak Diketahui',
                                author:
                                    book['author'] ?? 'Penulis Tidak Diketahui',
                                description: book['description'] as String?,
                                imageUrl: book['imageUrl'] as String?,
                                olid: book['olid'] as String?,
                                openLibraryUrl:
                                    book['openLibraryUrl'] as String?,
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
                              book['imageUrl'] as String? ??
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
                                  book['title'] ?? 'Judul Tidak Diketahui',
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
                                  book['author'] ?? 'Penulis Tidak Diketahui',
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
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                          ),
                                          onPressed: () {
                                            final String message;
                                            final Color iconColor;
                                            final IconData iconData;
                                            final Color backgroundColor;

                                            if (isInBookshelf) {
                                              bookshelfModel.removeBook(book);
                                              message =
                                                  '${book['title'] ?? 'Buku'} dihapus dari Rak Buku.';
                                              iconData = Icons.bookmark_remove;
                                              iconColor =
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onError;
                                              backgroundColor =
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.error;
                                            } else {
                                              bookshelfModel.addBook(book);
                                              message =
                                                  '${book['title'] ?? 'Buku'} disimpan ke Rak Buku.';
                                              iconData = Icons.bookmark_add;
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
                                                  '${book['title'] ?? 'Buku'} dihapus dari Favorit.';
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
                                                  '${book['title'] ?? 'Buku'} ditambahkan ke Favorit.';
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
