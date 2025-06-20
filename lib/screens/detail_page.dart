import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bookshelf_model.dart'; // pastikan file ini ada yaa

class DetailPage extends StatelessWidget {
  final String title;
  final String author;
  final String description;
  final String imageurl;

  const DetailPage({
    super.key,
    required this.title,
    required this.author,
    required this.description,
    required this.imageurl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Color(0xFFB3E5FC)),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(imageurl, height: 220, fit: BoxFit.cover),
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
            ElevatedButton(
              onPressed: () {
                final novel = {
                  'title': title,
                  'author': author,
                  'description': description,
                  'image': imageurl,
                };

                Provider.of<BookshelfModel>(
                  context,
                  listen: false,
                ).addBook(novel);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          'Buku berhasil disimpan ke Rak!',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    backgroundColor: Color(0xFFB3E5FC),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    elevation: 4,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB3E5FC),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Simpan ke Rak Buku',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),

      // ⭐ FAB Bookmark untuk menambahkan ke rak buku
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<BookshelfModel>(context, listen: false).addBook({
            'title': title,
            'author': author,
            'description': description,
            'image': imageurl,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berhasil ditambahkan ke Rak Buku!')),
          );
        },
        child: const Icon(Icons.bookmark_add),
        backgroundColor: Color(0xFFB3E5FC),
      ),
    );
  }
}
