import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bookshelf_model.dart';
import '../models/favorite_model.dart';
import '../services/book_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> _trendingBooks = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchTrendingBooks();
  }

  Future<void> _fetchTrendingBooks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final List<Map<String, String>> books =
          await BookService.fetchTrendingBooks();
      if (mounted) {
        setState(() {
          _trendingBooks = books;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat buku trending: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage, textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchTrendingBooks,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _trendingBooks.length,
                itemBuilder: (context, index) {
                  final book = _trendingBooks[index];

                  return TrendingBookCard(book: book);
                },
              ),
    );
  }
}

class TrendingBookCard extends StatelessWidget {
  final Map<String, String> book;

  const TrendingBookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      builder: (context, bookshelfModel, favoriteModel, child) {
                        final bool isInBookshelf = bookshelfModel.isInBookshelf(
                          book,
                        );
                        final bool isFavorite = favoriteModel.isFavorite(book);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Tombol Bookshelf
                            IconButton(
                              icon: Icon(
                                isInBookshelf
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color:
                                    isInBookshelf
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey,
                              ),
                              onPressed: () {
                                if (isInBookshelf) {
                                  bookshelfModel.removeBook(book);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${book['title']} dihapus dari Rak Buku.',
                                      ),
                                    ),
                                  );
                                } else {
                                  bookshelfModel.addBook(book);
                                  ScaffoldMessenger.of(context).showSnackBar(
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
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                favoriteModel.toggleFavorite(book);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFavorite
                                          ? '${book['title']} dihapus dari Favorit.'
                                          : '${book['title']} ditambahkan ke Favorit.',
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
  }
}
