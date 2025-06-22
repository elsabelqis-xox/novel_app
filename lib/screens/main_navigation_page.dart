// lib/screens/main_navigation_page.dart
import 'package:flutter/material.dart';
import '../screens/home_content_page.dart';
// import '../screens/search_page.dart'; // Hapus import ini karena sudah jadi SearchDelegate
import '../screens/bookshelf_page.dart';
import '../screens/favorite_page.dart';
import '../screens/settings_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  // Hapus SearchPage() dari daftar pages
  // Sekarang hanya ada 4 halaman yang ditampilkan di bottom navigation bar
  final List<Widget> _pages = const [
    HomeContentPage(), // Index 0
    BookshelfPage(), // Index 1 (sebelumnya 2)
    FavoritePage(), // Index 2 (sebelumnya 3)
    SettingsPage(), // Index 3 (sebelumnya 4)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          // Hapus BottomNavigationBarItem untuk 'Cari' jika fungsi search via AppBar
          // Atau, jika kamu tetap ingin ada tab 'Cari', kamu perlu membuat
          // Widget baru untuk SearchPage yang bukan SearchDelegate.
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Rak Buku',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
