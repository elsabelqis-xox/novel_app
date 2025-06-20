import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bookshelf_model.dart';
import 'detail_page.dart';

class BookshelfPage extends StatelessWidget {
  const BookshelfPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookshelf = Provider.of<BookshelfModel>(context).bookshelf;

    return Scaffold(
      backgroundColor: const Color(0xFFB3E5FC),
      appBar: AppBar(
        title: const Text('📚 Rak Buku'),
        backgroundColor: const Color(0xFFB3E5FC),
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookshelf.length,
        itemBuilder: (context, index) {
          final novel = bookshelf[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  novel['image']!,
                  width: 60,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                novel['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(novel['author']!),
                  const SizedBox(height: 4),
                  Text(
                    novel['description']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  Provider.of<BookshelfModel>(
                    context,
                    listen: false,
                  ).removeBook(novel);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Buku dihapus dari rak 📚❌'),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                },
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => DetailPage(
                          title: novel['title']!,
                          author: novel['author']!,
                          description: novel['description']!,
                          imageurl: novel['image']!,
                        ),
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Buku berhasil disimpan ke rak!',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: const Color(0xFFB3E5FC),
                    behavior: SnackBarBehavior.floating,
                    elevation: 4,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
