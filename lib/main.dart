import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/bookshelf_model.dart';
import 'models/favorite_model.dart';
import 'providers/theme_provider.dart';

// Import halaman-halaman utama
import 'screens/splash_screen.dart';
import 'screens/homepage.dart';
import 'screens/search_page.dart';
import 'screens/bookshelf_page.dart';
import 'screens/favorite_page.dart';
import 'screens/settings_page.dart';

const Color _appBarAndNavBarColorLight = Color.fromARGB(255, 141, 195, 248);
const Color _appBarAndNavBarColorDark = Color(0xFF212121);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _appBarAndNavBarColorLight,
    primary: _appBarAndNavBarColorLight,
    onPrimary: Colors.black,
    background: Colors.white,
    surface: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: _appBarAndNavBarColorLight,
    foregroundColor: Colors.black,
    elevation: 4,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
    unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
    type: BottomNavigationBarType.fixed,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _appBarAndNavBarColorLight,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
);

// --- Dark Theme ---
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _appBarAndNavBarColorDark,
    primary: _appBarAndNavBarColorDark,
    onPrimary: Colors.white,
    background: const Color.fromARGB(255, 54, 54, 54),
    surface: Colors.grey[850],
    brightness: Brightness.dark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 43, 43, 43),
    foregroundColor: Colors.white,
    elevation: 4,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    selectedItemColor: const Color.fromARGB(255, 97, 97, 97),
    unselectedItemColor: Colors.grey[400],
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
    type: BottomNavigationBarType.fixed,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueGrey[700],
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookshelfModel()),
        ChangeNotifierProvider(create: (context) => FavoriteModel()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Aplikasi Novel',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const BookshelfPage(),
    const FavoritePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Rak Buku',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
