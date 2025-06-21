import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteModel extends ChangeNotifier {
  final List<Map<String, String>> _favoriteNovels = [];
  static const String _favoriteKey = 'favorite_data';

  FavoriteModel() {
    _loadFavorites();
  }

  List<Map<String, String>> get favoriteNovels => _favoriteNovels;

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_favoriteKey);
    if (jsonString != null) {
      final List<dynamic> decodedList = json.decode(jsonString);
      _favoriteNovels.addAll(
        decodedList.map((item) => Map<String, String>.from(item)).toList(),
      );
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(_favoriteNovels);
    await prefs.setString(_favoriteKey, jsonString);
  }

  void toggleFavorite(Map<String, String> novel) {
    final isCurrentlyFavorite = _favoriteNovels.any(
      (favNovel) => favNovel['key'] == novel['key'],
    );

    if (isCurrentlyFavorite) {
      _favoriteNovels.removeWhere(
        (favNovel) => favNovel['key'] == novel['key'],
      );
    } else {
      _favoriteNovels.add(novel);
    }
    _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(Map<String, String> novel) {
    return _favoriteNovels.any((favNovel) => favNovel['key'] == novel['key']);
  }

  void addNovel(Map<String, String> novel) {
    if (!isFavorite(novel)) {
      _favoriteNovels.add(novel);
      _saveFavorites();
      notifyListeners();
    }
  }

  void removeNovel(Map<String, String> novel) {
    _favoriteNovels.removeWhere((favNovel) => favNovel['key'] == novel['key']);
    _saveFavorites();
    notifyListeners();
  }
}
