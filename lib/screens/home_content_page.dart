import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_page.dart'; // Ensure this import is correct

class HomeContentPage extends StatefulWidget {
  const HomeContentPage({Key? key}) : super(key: key);

  @override
  State<HomeContentPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  static const String _openLibraryBaseUrl = 'https://openlibrary.org';
  static const String _coversBaseUrl = 'https://covers.openlibrary.org/b';

  List<Map<String, String>> _popularNovels = [];
  List<Map<String, String>> _latestNovels = [];
  List<Map<String, String>> _recommendedNovels = [];

  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchBookData();
  }

  Future<void> _fetchBookData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      _popularNovels = await _fetchBooksFromOpenLibrary(
        '$_openLibraryBaseUrl/trending/now.json',
        'Popular',
      );

      _latestNovels = await _fetchBooksFromOpenLibrary(
        '$_openLibraryBaseUrl/search.json?q=novel&sort=new',
        'Latest',
      );

      _recommendedNovels = await _fetchBooksFromOpenLibrary(
        '$_openLibraryBaseUrl/search.json?q=fiction&subject=fantasy',
        'Recommended',
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data buku: $e';
      });
      print('Error fetching book data: $e');
    }
  }

  Future<List<Map<String, String>>> _fetchBooksFromOpenLibrary(
    String url,
    String categoryName,
  ) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, String>> books = [];

      List<dynamic> docs;
      if (data.containsKey('works')) {
        docs = data['works'];
      } else if (data.containsKey('docs')) {
        docs = data['docs'];
      } else if (data.containsKey('entries')) {
        docs = data['entries'];
      } else {
        return [];
      }

      for (var doc in docs) {
        String title = doc['title']?.toString() ?? 'Judul Tidak Diketahui';
        String author =
            (doc['author_name'] != null && doc['author_name'].isNotEmpty)
                ? doc['author_name'][0].toString()
                : 'Penulis Tidak Diketahui';

        String? olidRaw = doc['key']?.toString();
        String? olid;
        if (olidRaw != null) {
          olid = olidRaw.replaceAll('/works/', '');
        }

        String? coverId = doc['cover_i']?.toString();
        String bookUrl = '$_openLibraryBaseUrl${doc['key'] ?? ''}';

        String description = 'Deskripsi Tidak Tersedia';
        if (olid != null && olid.isNotEmpty) {
          try {
            description = await _fetchBookDescription(olid);
          } catch (e) {
            print('Error fetching description for $olid: $e');
            description = 'Gagal memuat deskripsi.';
          }
        }

        String imageUrl = _getCoverImageUrl(coverId);

        books.add({
          'title': title,
          'author': author,
          'description': description,
          'imageUrl': imageUrl,
          'openLibraryUrl': bookUrl,
          'olid': olid ?? '',
        });

        if (books.length >= 10) {
          break;
        }
      }
      return books;
    } else {
      throw Exception(
        'Gagal memuat buku $categoryName: ${response.statusCode}',
      );
    }
  }

  Future<String> _fetchBookDescription(String olid) async {
    final response = await http.get(
      Uri.parse('$_openLibraryBaseUrl/works/$olid.json'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('description')) {
        final dynamic desc = data['description'];
        if (desc is String) {
          return desc;
        } else if (desc is Map && desc.containsKey('value')) {
          return desc['value']?.toString() ?? '';
        }
      }
    }
    return 'Deskripsi tidak tersedia.';
  }

  String _getCoverImageUrl(String? coverId) {
    if (coverId != null && coverId.isNotEmpty) {
      return '$_coversBaseUrl/id/$coverId-M.jpg';
    }
    return 'https://via.placeholder.com/150x200?text=No+Cover';
  }

  Widget _buildBookList(List<Map<String, String>> books) {
    if (books.isEmpty) {
      return const Center(
        child: Text('Tidak ada buku yang tersedia di kategori ini.'),
      );
    }
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => DetailPage(
                        title: book['title']!,
                        author: book['author']!,
                        description: book['description'],
                        imageUrl: book['imageUrl'],
                        olid: book['olid'],
                        openLibraryUrl: book['openLibraryUrl'],
                      ),
                ),
              );
            },
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      book['imageUrl'] ??
                          'https://via.placeholder.com/150x200?text=No+Cover',
                      height: 180,
                      width: 150,
                      fit: BoxFit.cover,

                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 180,
                          width: 150,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
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
                          height: 180,
                          width: 150,
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(
                              Icons.book,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    book['title']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    book['author']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Library Books📚'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Novel Populer'),
                      _buildBookList(_popularNovels),
                      const SizedBox(height: 24),
                      _buildSectionHeader('Novel Terbaru'),
                      _buildBookList(_latestNovels),
                      const SizedBox(height: 24),
                      _buildSectionHeader('Novel Rekomendasi'),
                      _buildBookList(_recommendedNovels),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
