import 'dart:convert';
import 'package:http/http.dart' as http;

class BookService {
  static const String _baseUrl = 'https://openlibrary.org';

  static Future<List<Map<String, dynamic>>> fetchTrendingBooks() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/trending/daily.json?limit=20'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> works = data['works'] ?? [];

      List<Map<String, dynamic>> books = [];
      for (var work in works) {
        final title = work['title']?.toString() ?? 'Judul Tidak Tersedia';
        final author =
            (work['author_name'] as List?)?.join(', ') ??
            'Penulis Tidak Tersedia';
        final coverId = work['cover_id']?.toString();

        final olid = (work['key'] as String?)?.replaceAll('/works/', '');

        String? imageUrl;
        if (coverId != null) {
          imageUrl = 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
        }

        String description = 'Deskripsi tidak tersedia.';
        if (work['first_sentence'] != null) {
          if (work['first_sentence'] is Map &&
              work['first_sentence']['value'] is String) {
            description = work['first_sentence']['value'].toString();
          } else if (work['first_sentence'] is String) {
            description = work['first_sentence'].toString();
          }
        }

        final openLibraryUrl = '$_baseUrl${work['key'] ?? ''}';

        books.add({
          'key': work['key']?.toString() ?? '',
          'title': title,
          'author': author,
          'description': description,
          'imageUrl': imageUrl,
          'olid': olid ?? '',
          'openLibraryUrl': openLibraryUrl,
        });
      }
      return books;
    } else {
      throw Exception('Gagal memuat buku trending: ${response.statusCode}');
    }
  }

  static Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search.json?q=$query&limit=20'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> docs = data['docs'] ?? [];

      List<Map<String, dynamic>> books = [];
      for (var doc in docs) {
        final title = doc['title']?.toString() ?? 'Judul Tidak Tersedia';
        final author =
            (doc['author_name'] as List?)?.join(', ') ??
            'Penulis Tidak Tersedia';
        final coverId = doc['cover_i']?.toString();
        final olid = (doc['key'] as String?)?.replaceAll('/works/', '');

        String? imageUrl;
        if (coverId != null) {
          imageUrl = 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
        }

        final description =
            doc['first_sentence']?.toString() ?? 'Deskripsi tidak tersedia.';

        final openLibraryUrl = '$_baseUrl${doc['key'] ?? ''}';

        books.add({
          'key': doc['key']?.toString() ?? '',
          'title': title,
          'author': author,
          'description': description,
          'imageUrl': imageUrl,
          'olid': olid ?? '',
          'openLibraryUrl': openLibraryUrl,
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

  static Future<String?> getBookDescription(String olid) async {
    try {
      final Map<String, dynamic> detail = await fetchDetailByOLID(olid);
      dynamic description = detail['description'];
      if (description is Map && description.containsKey('value')) {
        return description['value']?.toString();
      } else if (description is String) {
        return description;
      }
      return null;
    } catch (e) {
      print('Error getting detailed description for OLID $olid: $e');
      return null;
    }
  }
}
