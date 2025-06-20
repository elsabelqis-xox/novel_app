import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/bookshelf_model.dart';
import 'models/theme_provider.dart';
import 'screens/homepage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookshelfModel()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
      title: 'Novel App',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        // PERBAIKAN DI SINI: tambahkan brightness: Brightness.light
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB3E5FC),
          brightness: Brightness.light, // Pastikan ini juga light
        ),
        useMaterial3: true,
        brightness: Brightness.light, // Ini sudah benar
      ),
      darkTheme: ThemeData(
        // PERBAIKAN DI SINI: tambahkan brightness: Brightness.dark
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark, // Pastikan ini juga dark
        ),
        useMaterial3: true,
        brightness: Brightness.dark, // Ini sudah benar
      ),
      home: const HomePage(),
    );
  }
}
