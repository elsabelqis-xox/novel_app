import 'dart:convert';
import 'package:http/http.dart' as http;

class BookService {
  static Future<Map<String, dynamic>> fetchBookMetadata(String isbn) async {
    final url =
        'https://openlibrary.org/api/books?bibkeys=ISBN:$isbn&format=json&jscmd=data';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final key = 'ISBN:$isbn';
      return data[key] ?? {};
    } else {
      throw Exception('Gagal mengambil metadata buku');
    }
  }
}
