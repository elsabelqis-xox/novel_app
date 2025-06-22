import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/bookshelf_model.dart';
import 'models/favorite_model.dart';
import 'providers/theme_provider.dart';

import 'screens/splash_screen.dart';
import 'screens/home_content_page.dart';
import 'screens/bookshelf_page.dart';
import 'screens/favorite_page.dart';
import 'screens/settings_page.dart';

const Color _lightPrimaryColor = Color.fromARGB(255, 141, 195, 248);
const Color _lightScaffoldBackgroundColor = Color.fromARGB(255, 230, 240, 255);
const Color _darkPrimaryColor = Color(0xFF303030);
const Color _darkBackgroundColor = Color.fromARGB(255, 43, 43, 43);

// --- Light Theme ---
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: _lightScaffoldBackgroundColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _lightPrimaryColor,
    primary: _lightPrimaryColor,
    onPrimary: Colors.black,
    primaryContainer: const Color.fromARGB(255, 200, 220, 255),
    onPrimaryContainer: Colors.black,
    secondary: const Color.fromARGB(255, 255, 193, 7),
    onSecondary: Colors.black,
    background: _lightScaffoldBackgroundColor,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: _lightPrimaryColor,
    foregroundColor: Colors.white,
    elevation: 4,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.poppins().fontFamily,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: _lightPrimaryColor,
    unselectedItemColor: Colors.grey[600],
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
    type: BottomNavigationBarType.fixed,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _lightPrimaryColor,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: _lightPrimaryColor,
    contentTextStyle: const TextStyle(color: Colors.black),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    behavior: SnackBarBehavior.floating,
    actionTextColor: Colors.black,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
);

// --- Dark Theme ---
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: _darkBackgroundColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _darkPrimaryColor,
    primary: _darkPrimaryColor,
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFF424242),
    onPrimaryContainer: Colors.white,
    secondary: Colors.tealAccent[400],
    onSecondary: Colors.black,
    background: _darkBackgroundColor,
    onBackground: Colors.white,
    surface: const Color(0xFF212121),
    onSurface: Colors.white,
    error: Colors.redAccent,
    onError: Colors.black,
    brightness: Brightness.dark,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: _darkBackgroundColor,
    foregroundColor: Colors.white,
    elevation: 4,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.poppins().fontFamily,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.white,
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
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey[800],
    contentTextStyle: const TextStyle(color: Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    behavior: SnackBarBehavior.floating,
    actionTextColor: Colors.white,
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

  final List<Widget> _pages = const [
    HomeContentPage(),
    BookshelfPage(),
    FavoritePage(),
    SettingsPage(),
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

          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Rak Buku',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
