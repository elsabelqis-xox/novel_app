import 'dart:convert';
import 'package:http/http.dart' as http;

class BookService {
  static const String _baseUrl = 'https://openlibrary.org';

  static Future<List<Map<String, String>>> fetchTrendingBooks() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/trending/daily.json?limit=20'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> works = data['works'] ?? [];

      List<Map<String, String>> books = [];
      for (var work in works) {
        final title = work['title']?.toString() ?? 'Judul Tidak Tersedia';
        final author =
            (work['author_name'] as List?)?.join(', ') ??
            'Penulis Tidak Tersedia';
        final coverId = work['cover_id']?.toString();
        final olid = (work['key'] as String?)?.replaceAll('/works/', '');

        String imageUrl =
            coverId != null
                ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
                : 'https://via.placeholder.com/150x200?text=No+Image';

        final description =
            work['first_sentence']?['value']?.toString() ??
            'Deskripsi tidak tersedia.';

        books.add({
          'key': olid ?? '${title}_$author',
          'title': title,
          'author': author,
          'description': description,
          'image': imageUrl,
          'olid': olid ?? '',
        });
      }
      return books;
    } else {
      throw Exception('Gagal memuat buku trending: ${response.statusCode}');
    }
  }

  static Future<List<Map<String, String>>> searchBooks(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search.json?q=$query&limit=20'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> docs = data['docs'] ?? [];

      List<Map<String, String>> books = [];
      for (var doc in docs) {
        final title = doc['title']?.toString() ?? 'Judul Tidak Tersedia';
        final author =
            (doc['author_name'] as List?)?.join(', ') ??
            'Penulis Tidak Tersedia';
        final coverId = doc['cover_i']?.toString();
        final olid = (doc['key'] as String?)?.replaceAll('/works/', '');

        String imageUrl =
            coverId != null
                ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
                : 'https://via.placeholder.com/150x200?text=No+Image';

        final description =
            doc['first_sentence']?.toString() ?? 'Deskripsi tidak tersedia.';

        books.add({
          'key': olid ?? '${title}_$author',
          'title': title,
          'author': author,
          'description': description,
          'image': imageUrl,
          'olid': olid ?? '',
        });
      }
      return books;
    } else {
      throw Exception('Gagal melakukan pencarian: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> fetchDetailByOLID(String olid) async {
    final response = await http.get(Uri.parse('$_baseUrl/works/$olid.json'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Gagal memuat detail buku untuk OLID: $olid (${response.statusCode})',
      );
    }
  }
}
