import 'package:flutter/material.dart'; // Menggunakan material.dart karena ChangeNotifier
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteModel extends ChangeNotifier {
  // Mengubah tipe data dari List<Map<String, String>> menjadi List<Map<String, dynamic>>
  final List<Map<String, dynamic>> _favoriteNovels = [];
  static const String _favoriteKey = 'favorite_data';

  FavoriteModel() {
    _loadFavorites();
  }

  // Mengubah tipe data yang dikembalikan oleh getter
  List<Map<String, dynamic>> get favoriteNovels => _favoriteNovels;

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_favoriteKey);
    if (jsonString != null) {
      final List<dynamic> decodedList = json.decode(jsonString);
      _favoriteNovels.addAll(
        // Map item to Map<String, dynamic>
        decodedList.map((item) => Map<String, dynamic>.from(item)).toList(),
      );
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // json.encode sudah bisa menangani List<Map<String, dynamic>>
    final String jsonString = json.encode(_favoriteNovels);
    await prefs.setString(_favoriteKey, jsonString);
  }

  // Helper function untuk mendapatkan ID unik dari buku
  // Prioritaskan 'olid', fallback ke 'key'
  dynamic _getUniqueId(Map<String, dynamic> novel) {
    return novel['olid'] ?? novel['key'];
  }

  // Mengubah tipe data parameter novel
  void toggleFavorite(Map<String, dynamic> novel) {
    final dynamic novelId = _getUniqueId(novel);
    if (novelId == null)
      return; // Tidak bisa mengelola favorit jika tidak ada ID

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

  // Mengubah tipe data parameter novel
  bool isFavorite(Map<String, dynamic> novel) {
    final dynamic novelId = _getUniqueId(novel);
    if (novelId == null) return false; // Bukan favorit jika tidak ada ID

    return _favoriteNovels.any((favNovel) => _getUniqueId(favNovel) == novelId);
  }

  // Mengubah tipe data parameter novel
  void addNovel(Map<String, dynamic> novel) {
    if (!isFavorite(novel)) {
      _favoriteNovels.add(novel);
      _saveFavorites();
      notifyListeners();
    }
  }

  // Mengubah tipe data parameter novel
  void removeNovel(Map<String, dynamic> novel) {
    final dynamic novelId = _getUniqueId(novel);
    if (novelId == null) return; // Tidak bisa menghapus jika tidak ada ID

    _favoriteNovels.removeWhere(
      (favNovel) => _getUniqueId(favNovel) == novelId,
    );
    _saveFavorites();
    notifyListeners();
  }
}
