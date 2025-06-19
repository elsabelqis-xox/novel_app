import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bookshelf_model.dart'; // pastikan kamu punya file model ini yaa

class DetailPage extends StatelessWidget {
  final String title;
  final String author;
  final String description;
  final String image;

  const DetailPage({
    super.key,
    required this.title,
    required this.author,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(image, height: 220, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            Text(
              author,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Text(description, style: const TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 16),

            // ⭐ ElevatedButton untuk simpan ke rak buku
            ElevatedButton(
              onPressed: () {
                final novel = {
                  'title': title,
                  'author': author,
                  'description': description,
                  'image': image,
                };

                Provider.of<BookshelfModel>(
                  context,
                  listen: false,
                ).addBook(novel);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Berhasil disimpan ke rak buku'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Simpan ke Rak Buku',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
