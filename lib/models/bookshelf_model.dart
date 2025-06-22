import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookshelfModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _bookshelf = [];
  static const String _bookshelfKey = 'bookshelf_data';

  BookshelfModel() {
    _loadBookshelf();
  }

  List<Map<String, dynamic>> get bookshelf => _bookshelf;

  Future<void> _loadBookshelf() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_bookshelfKey);
    if (jsonString != null) {
      final List<dynamic> decodedList = json.decode(jsonString);
      _bookshelf.addAll(
        decodedList.map((item) => Map<String, dynamic>.from(item)).toList(),
      );
      notifyListeners();
    }
  }

  Future<void> _saveBookshelf() async {
    final prefs = await SharedPreferences.getInstance();

    final String jsonString = json.encode(_bookshelf);
    await prefs.setString(_bookshelfKey, jsonString);
  }

  void addBook(Map<String, dynamic> book) {
    final dynamic uniqueId = book['olid'] ?? book['key'];
    if (uniqueId == null) {
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

  void removeBook(Map<String, dynamic> book) {
    final dynamic uniqueId = book['olid'] ?? book['key'];
    if (uniqueId == null) {
      return;
    }

    _bookshelf.removeWhere((item) {
      final dynamic itemUniqueId = item['olid'] ?? item['key'];
      return itemUniqueId == uniqueId;
    });
    _saveBookshelf();
    notifyListeners();
  }

  bool isInBookshelf(Map<String, dynamic> book) {
    final dynamic uniqueId = book['olid'] ?? book['key'];
    if (uniqueId == null) {
      return false;
    }
    return _bookshelf.any((item) {
      final dynamic itemUniqueId = item['olid'] ?? item['key'];
      return itemUniqueId == uniqueId;
    });
  }
}
