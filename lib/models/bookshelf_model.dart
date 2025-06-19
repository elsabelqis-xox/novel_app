import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class BookshelfModel extends ChangeNotifier {
  final List<Map<String, String>> _bookshelf = [];

  List<Map<String, String>> get bookshelf => _bookshelf;

  void addBook(Map<String, String> novel) {
    _bookshelf.add(novel);
    notifyListeners();
  }
}
