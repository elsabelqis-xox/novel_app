import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookshelfModel extends ChangeNotifier {
  // Mengubah tipe data dari List<Map<String, String>> menjadi List<Map<String, dynamic>>
  final List<Map<String, dynamic>> _bookshelf = [];
  static const String _bookshelfKey = 'bookshelf_data';

  BookshelfModel() {
    _loadBookshelf();
  }

  // Mengubah tipe data yang dikembalikan oleh getter
  List<Map<String, dynamic>> get bookshelf => _bookshelf;

  Future<void> _loadBookshelf() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_bookshelfKey);
    if (jsonString != null) {
      final List<dynamic> decodedList = json.decode(jsonString);
      _bookshelf.addAll(
        // Map item to Map<String, dynamic>
        decodedList.map((item) => Map<String, dynamic>.from(item)).toList(),
      );
      notifyListeners();
    }
  }

  Future<void> _saveBookshelf() async {
    final prefs = await SharedPreferences.getInstance();
    // json.encode sudah bisa menangani List<Map<String, dynamic>>
    final String jsonString = json.encode(_bookshelf);
    await prefs.setString(_bookshelfKey, jsonString);
  }

  // Mengubah tipe data parameter book
  void addBook(Map<String, dynamic> book) {
    // Gunakan 'olid' sebagai kunci unik jika tersedia, jika tidak 'key'
    final dynamic uniqueId = book['olid'] ?? book['key'];
    if (uniqueId == null) {
      // Handle case where neither olid nor key is present (shouldn't happen with valid book data)
      return;
    }

    final bool exists = _bookshelf.any((item) {
      final dynamic itemUniqueId = item['olid'] ?? item['key'];
      return itemUniqueId == uniqueId;
    });

    if (!exists) {
      _bookshelf.add(book);
      _saveBookshelf();
      notifyListeners();
    }
  }

  // Mengubah tipe data parameter book
  void removeBook(Map<String, dynamic> book) {
    // Gunakan 'olid' sebagai kunci unik jika tersedia, jika tidak 'key'
    final dynamic uniqueId = book['olid'] ?? book['key'];
    if (uniqueId == null) {
      return; // Tidak bisa menghapus jika tidak ada id unik
    }

    _bookshelf.removeWhere((item) {
      final dynamic itemUniqueId = item['olid'] ?? item['key'];
      return itemUniqueId == uniqueId;
    });
    _saveBookshelf();
    notifyListeners();
  }

  // Mengubah tipe data parameter book
  bool isInBookshelf(Map<String, dynamic> book) {
    // Gunakan 'olid' sebagai kunci unik jika tersedia, jika tidak 'key'
    final dynamic uniqueId = book['olid'] ?? book['key'];
    if (uniqueId == null) {
      return false; // Jika buku tidak memiliki id unik, anggap tidak ada di rak
    }
    return _bookshelf.any((item) {
      final dynamic itemUniqueId = item['olid'] ?? item['key'];
      return itemUniqueId == uniqueId;
    });
  }
}
