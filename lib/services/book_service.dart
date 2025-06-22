// lib/services/book_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookService {
  static const String _baseUrl = 'https://openlibrary.org';

  // Fungsi untuk mengambil buku trending harian
  static Future<List<Map<String, dynamic>>> fetchTrendingBooks() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/trending/daily.json?limit=20'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> works = data['works'] ?? [];

      List<Map<String, dynamic>> books = []; // Ubah ke dynamic
      for (var work in works) {
        final title = work['title']?.toString() ?? 'Judul Tidak Tersedia';
        final author =
            (work['author_name'] as List?)?.join(', ') ??
            'Penulis Tidak Tersedia';
        final coverId = work['cover_id']?.toString();
        // OLID bisa langsung dari work['key'] yang formatnya /works/OLXXXXXW
        final olid = (work['key'] as String?)?.replaceAll('/works/', '');

        String? imageUrl; // Bisa null jika tidak ada coverId
        if (coverId != null) {
          imageUrl =
              'https://covers.openlibrary.org/b/id/$coverId-M.jpg'; // Menggunakan ukuran M untuk konsistensi
        }

        // Deskripsi dari trending API seringkali berupa map {'value': '...' }
        String description = 'Deskripsi tidak tersedia.';
        if (work['first_sentence'] != null) {
          if (work['first_sentence'] is Map &&
              work['first_sentence']['value'] is String) {
            description = work['first_sentence']['value'].toString();
          } else if (work['first_sentence'] is String) {
            description = work['first_sentence'].toString();
          }
        }

        // URL ke halaman buku di Open Library
        final openLibraryUrl = '$_baseUrl${work['key'] ?? ''}';

        books.add({
          'key': work['key']?.toString() ?? '', // Simpan key asli dari API
          'title': title,
          'author': author,
          'description': description,
          'imageUrl': imageUrl, // Gunakan 'imageUrl'
          'olid': olid ?? '', // Pastikan olid ada
          'openLibraryUrl': openLibraryUrl, // Tambahkan ini
        });
      }
      return books;
    } else {
      throw Exception('Gagal memuat buku trending: ${response.statusCode}');
    }
  }

  // Fungsi untuk mencari buku berdasarkan query
  static Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search.json?q=$query&limit=20'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> docs = data['docs'] ?? [];

      List<Map<String, dynamic>> books = []; // Ubah ke dynamic
      for (var doc in docs) {
        final title = doc['title']?.toString() ?? 'Judul Tidak Tersedia';
        final author =
            (doc['author_name'] as List?)?.join(', ') ??
            'Penulis Tidak Tersedia';
        final coverId = doc['cover_i']?.toString();
        final olid = (doc['key'] as String?)?.replaceAll('/works/', '');

        String? imageUrl; // Bisa null jika tidak ada coverId
        if (coverId != null) {
          imageUrl =
              'https://covers.openlibrary.org/b/id/$coverId-M.jpg'; // Menggunakan ukuran M untuk konsistensi
        }

        // Deskripsi dari search API seringkali langsung string
        final description =
            doc['first_sentence']?.toString() ?? 'Deskripsi tidak tersedia.';

        // URL ke halaman buku di Open Library
        final openLibraryUrl = '$_baseUrl${doc['key'] ?? ''}';

        books.add({
          'key': doc['key']?.toString() ?? '', // Simpan key asli dari API
          'title': title,
          'author': author,
          'description': description,
          'imageUrl': imageUrl, // Gunakan 'imageUrl'
          'olid': olid ?? '', // Pastikan olid ada
          'openLibraryUrl': openLibraryUrl, // Tambahkan ini
        });
      }
      return books;
    } else {
      throw Exception('Gagal melakukan pencarian: ${response.statusCode}');
    }
  }

  // Fungsi untuk mengambil detail buku berdasarkan OLID (lebih lengkap)
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

  // Fungsi tambahan untuk mendapatkan deskripsi dari detail buku OLID
  // Bisa dipanggil di DetailPage untuk mendapatkan deskripsi yang lebih panjang
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
