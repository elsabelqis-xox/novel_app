import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Future<void> searchBooks(String keyword) async {
    setState(() => _isLoading = true);
    final url = 'https://openlibrary.org/search.json?q=$keyword&limit=10';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _searchResults = data['docs'];
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      throw Exception('Gagal mengambil data buku');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Buku')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Masukkan judul atau penulis...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => searchBooks(_searchController.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final book = _searchResults[index];
                    final title = book['title'] ?? 'Tanpa Judul';
                    final author =
                        (book['author_name'] != null &&
                                book['author_name'].isNotEmpty)
                            ? book['author_name'][0]
                            : 'Tanpa Penulis';
                    final coverId = book['cover_i'];
                    final imageUrl =
                        coverId != null
                            ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
                            : 'https://via.placeholder.com/100x150?text=No+Image';

                    return ListTile(
                      leading: Image.network(imageUrl, width: 50, height: 75),
                      title: Text(title),
                      subtitle: Text(author),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DetailPage(
                                  title: title,
                                  author: author,
                                  description:
                                      'Deskripsi belum tersedia dari API',
                                  imageurl: imageUrl,
                                ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
