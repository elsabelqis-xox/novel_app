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

      // Fetch Popular Novels (using trending/now as a proxy for popular)
      _popularNovels = await _fetchBooksFromOpenLibrary(
        '$_openLibraryBaseUrl/trending/now.json',
        'Popular',
      );

      // Fetch Latest Novels (searching by a general query and sorting by publish year)
      _latestNovels = await _fetchBooksFromOpenLibrary(
        '$_openLibraryBaseUrl/search.json?q=novel&sort=new',
        'Latest',
      );

      // Fetch Recommended Novels (searching by a general subject like 'fantasy')
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

      // Handle different API response structures
      List<dynamic> docs;
      if (data.containsKey('works')) {
        // For /trending/now which can sometimes return 'works'
        docs = data['works'];
      } else if (data.containsKey('docs')) {
        // For /search.json
        docs = data['docs'];
      } else if (data.containsKey('entries')) {
        // For /subjects/{subject}.json (though search is more general)
        docs = data['entries'];
      } else {
        return []; // Unknown format
      }

      for (var doc in docs) {
        // PERBAIKAN UTAMA DI SINI: PASTIKAN SEMUA NILAI NON-NULL UNTUK MAP<STRING, STRING>
        String title = doc['title']?.toString() ?? 'Judul Tidak Diketahui';
        String author =
            (doc['author_name'] != null && doc['author_name'].isNotEmpty)
                ? doc['author_name'][0].toString()
                : 'Penulis Tidak Diketahui';

        // OLID perlu diperhatikan, pastikan tidak null sebelum digunakan untuk fetch description
        String? olidRaw = doc['key']?.toString();
        String? olid;
        if (olidRaw != null) {
          olid = olidRaw.replaceAll(
            '/works/',
            '',
          ); // Get OLID for works, remove prefix
        }

        String? coverId = doc['cover_i']?.toString();
        String bookUrl =
            '$_openLibraryBaseUrl${doc['key'] ?? ''}'; // Pastikan URL selalu string, tambahkan '' jika null

        // Hanya proses jika OLID valid dan tersedia untuk deskripsi
        String description = 'Deskripsi Tidak Tersedia'; // Default value
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
          'title': title, // Sudah dijamin non-null
          'author': author, // Sudah dijamin non-null
          'description': description, // Sudah dijamin non-null
          'imageUrl': imageUrl, // Sudah dijamin non-null
          'openLibraryUrl': bookUrl, // Sudah dijamin non-null
          'olid':
              olid ??
              '', // Pastikan olid selalu string, jika null jadi string kosong
        });

        if (books.length >= 10) {
          break; // Limit to 10 books per category for display
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
          return desc['value']?.toString() ??
              ''; // Pastikan toString() dan fallback ke ''
        }
      }
    }
    return 'Deskripsi tidak tersedia.'; // Return default string if no description found or fetch fails
  }

  String _getCoverImageUrl(String? coverId) {
    if (coverId != null && coverId.isNotEmpty) {
      return '$_coversBaseUrl/id/$coverId-M.jpg'; // Medium size cover
    }
    return 'https://via.placeholder.com/150x200?text=No+Cover'; // Placeholder image
  }

  Widget _buildBookList(List<Map<String, String>> books) {
    if (books.isEmpty) {
      return const Center(
        child: Text('Tidak ada buku yang tersedia di kategori ini.'),
      );
    }
    return SizedBox(
      height: 250, // Adjust height as needed
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
                        // PERBAIKAN UTAMA DI SINI: PENAMAAN PARAMETER DAN PENGHAPUSAN '!'
                        title:
                            book['title']!, // title dan author harusnya sudah aman non-null dari Map
                        author: book['author']!,
                        description:
                            book['description'], // TIDAK PAKAI '!' karena di DetailPage sudah String?
                        imageUrl:
                            book['imageUrl'], // TIDAK PAKAI '!' dan perbaiki 'imageurl' jadi 'imageUrl'
                        olid: book['olid'], // Cukup begini
                        openLibraryUrl:
                            book['openLibraryUrl'], // TIDAK PAKAI '!'
                      ),
                ),
              );
            },
            child: Container(
              width: 150, // Adjust width as needed
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      // PERBAIKAN DI SINI JUGA: PENAMAAN PARAMETER DAN FALLBACK
                      book['imageUrl']!, // Ini seharusnya sudah non-null dari Map
                      height: 180,
                      width: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          width: 150,
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
                  const SizedBox(height: 8.0),
                  Text(
                    book['title']!, // Seharusnya aman non-null dari Map
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    book['author']!, // Seharusnya aman non-null dari Map
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
      appBar: AppBar(title: const Text('Open Library Books📚')),
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
                      const Text(
                        'Novel Populer',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildBookList(_popularNovels),
                      const SizedBox(height: 20),
                      const Text(
                        'Novel Terbaru',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildBookList(_latestNovels),
                      const SizedBox(height: 20),
                      const Text(
                        'Novel Rekomendasi',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildBookList(_recommendedNovels),
                    ],
                  ),
                ),
              ),
    );
  }
}
