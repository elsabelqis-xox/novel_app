import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _favoriteNovels = [];
  static const String _favoriteKey = 'favorite_data';

  FavoriteModel() {
    _loadFavorites();
  }

  List<Map<String, dynamic>> get favoriteNovels => _favoriteNovels;

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_favoriteKey);
    if (jsonString != null) {
      final List<dynamic> decodedList = json.decode(jsonString);
      _favoriteNovels.addAll(
        decodedList.map((item) => Map<String, dynamic>.from(item)).toList(),
      );
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final String jsonString = json.encode(_favoriteNovels);
    await prefs.setString(_favoriteKey, jsonString);
  }

  dynamic _getUniqueId(Map<String, dynamic> novel) {
    return novel['olid'] ?? novel['key'];
  }

  void toggleFavorite(Map<String, dynamic> novel) {
    final dynamic novelId = _getUniqueId(novel);
    if (novelId == null) return;

    final isCurrentlyFavorite = _favoriteNovels.any(
      (favNovel) => _getUniqueId(favNovel) == novelId,
    );

    if (isCurrentlyFavorite) {
      _favoriteNovels.removeWhere(
        (favNovel) => _getUniqueId(favNovel) == novelId,
      );
    } else {
      _favoriteNovels.add(novel);
    }
    _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(Map<String, dynamic> novel) {
    final dynamic novelId = _getUniqueId(novel);
    if (novelId == null) return false;

    return _favoriteNovels.any((favNovel) => _getUniqueId(favNovel) == novelId);
  }

  void addNovel(Map<String, dynamic> novel) {
    if (!isFavorite(novel)) {
      _favoriteNovels.add(novel);
      _saveFavorites();
      notifyListeners();
    }
  }

  void removeNovel(Map<String, dynamic> novel) {
    final dynamic novelId = _getUniqueId(novel);
    if (novelId == null) return;

    _favoriteNovels.removeWhere(
      (favNovel) => _getUniqueId(favNovel) == novelId,
    );
    _saveFavorites();
    notifyListeners();
  }
}
