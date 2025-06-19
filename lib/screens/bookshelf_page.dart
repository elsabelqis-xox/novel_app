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
      appBar: AppBar(
        title: const Text('📚 Rak Buku'),
        backgroundColor: Colors.deepPurple,
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => DetailPage(
                          title: novel['title']!,
                          author: novel['author']!,
                          description: novel['description']!,
                          image: novel['image']!,
                        ),
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
