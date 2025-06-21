import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookshelfModel extends ChangeNotifier {
  final List<Map<String, String>> _bookshelf = [];
  static const String _bookshelfKey = 'bookshelf_data';

  BookshelfModel() {
    _loadBookshelf();
  }

  List<Map<String, String>> get bookshelf => _bookshelf;

  Future<void> _loadBookshelf() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_bookshelfKey);
    if (jsonString != null) {
      final List<dynamic> decodedList = json.decode(jsonString);
      _bookshelf.addAll(
        decodedList.map((item) => Map<String, String>.from(item)).toList(),
      );

      notifyListeners();
    }
  }

  Future<void> _saveBookshelf() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(_bookshelf);
    await prefs.setString(_bookshelfKey, jsonString);
  }

  void addBook(Map<String, String> book) {
    final bool exists = _bookshelf.any((item) => item['key'] == book['key']);
    if (!exists) {
      _bookshelf.add(book);
      _saveBookshelf();
      notifyListeners();
    }
  }

  void removeBook(Map<String, String> book) {
    _bookshelf.removeWhere((item) => item['key'] == book['key']);
    _saveBookshelf();
    notifyListeners();
  }

  bool isInBookshelf(Map<String, String> book) {
    return _bookshelf.any((item) => item['key'] == book['key']);
  }
}
