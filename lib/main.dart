import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/bookshelf_model.dart';
import 'screens/homepage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BookshelfModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Novel App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(), // arahkan ke homepage kita
    );
  }
}
