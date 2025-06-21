// lib/screens/book_detail_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/bookshelf_model.dart';
import '../models/favorite_model.dart';
import '../services/book_service.dart';

class DetailPage extends StatefulWidget {
  final String title;
  final String author;
  final String description;
  final String imageurl;
  final String? olid;

  const DetailPage({
    super.key,
    required this.title,
    required this.author,
    required this.description,
    required this.imageurl,
    this.olid,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late String _description;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _description = widget.description;

    if (widget.olid != null &&
        widget.olid!.isNotEmpty &&
        (_description.contains('Deskripsi tidak tersedia') ||
            _description.isEmpty ||
            _description.trim().length < 100)) {
      _fetchDescriptionByOLID(widget.olid!);
    }
  }

  Future<void> _fetchDescriptionByOLID(String olid) async {
    setState(() => _loading = true);
    try {
      final cleanedOlid =
          olid.startsWith('/works/') ? olid.substring('/works/'.length) : olid;
      final data = await BookService.fetchDetailByOLID(cleanedOlid);
      final desc = data['description'];

      if (mounted) {
        setState(() {
          _description =
              (desc is Map)
                  ? desc['value']?.toString() ?? widget.description
                  : desc?.toString() ?? widget.description;
          if (_description.trim().isEmpty) {
            _description = widget.description;
          }
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        _description =
            widget.description.isNotEmpty
                ? widget.description
                : 'Deskripsi gagal dimuat.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat deskripsi lengkap: ${e.toString()}'),
          ),
        );
      }
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak bisa membuka link: $urlString')),
        );
      }
    }
  }

  String? get _openLibraryWebUrl {
    if (widget.olid != null && widget.olid!.isNotEmpty) {
      final cleanId =
          widget.olid!.startsWith('/works/')
              ? widget.olid!.substring('/works/'.length)
              : widget.olid;
      return 'https://openlibrary.org/works/$cleanId';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> currentBookData = {
      'key': widget.olid ?? '${widget.title}_${widget.author}',
      'title': widget.title,
      'author': widget.author,
      'description': _description,
      'image': widget.imageurl,
      'olid': widget.olid ?? '',
    };

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.imageurl,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 250,
                      width: 180,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.broken_image,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.author,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),

            _loading
                ? const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                )
                : Text(
                  _description.isEmpty
                      ? 'Deskripsi tidak tersedia.'
                      : _description,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
            const SizedBox(height: 24),

            if (_openLibraryWebUrl != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _launchUrl(_openLibraryWebUrl!);
                  },
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text('Baca Full Buku di Open Library'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Consumer<BookshelfModel>(
              builder: (context, bookshelfModel, _) {
                final bool isInBookshelf = bookshelfModel.isInBookshelf(
                  currentBookData,
                );
                return ElevatedButton.icon(
                  onPressed: () {
                    if (isInBookshelf) {
                      bookshelfModel.removeBook(currentBookData);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${currentBookData['title']} dihapus dari Rak Buku.',
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    } else {
                      bookshelfModel.addBook(currentBookData);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${currentBookData['title']} disimpan ke Rak Buku 📚',
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isInBookshelf
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  icon: Icon(
                    isInBookshelf ? Icons.bookmark_remove : Icons.bookmark_add,
                  ),
                  label: Text(
                    isInBookshelf ? 'Di Rak Buku' : 'Simpan ke Rak',
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              },
            ),
            Consumer<FavoriteModel>(
              builder: (context, favoriteModel, _) {
                final bool isFavorite = favoriteModel.isFavorite(
                  currentBookData,
                );
                return ElevatedButton.icon(
                  onPressed: () {
                    favoriteModel.toggleFavorite(currentBookData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFavorite
                              ? '${currentBookData['title']} dihapus dari Favorit.'
                              : '${currentBookData['title']} ditambahkan ke Favorit ❤️',
                        ),
                        backgroundColor:
                            isFavorite ? Colors.redAccent : Colors.pink,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFavorite ? Colors.red : Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  label: Text(
                    isFavorite ? 'Favorit' : 'Tambahkan Favorit',
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
