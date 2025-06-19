import 'package:flutter/material.dart';
import 'package:novel_app/screens/detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> novels = [
      {
        'title': 'Langit yang Tak Sama',
        'author': 'Ayu Lestari',
        'description': 'Kisah cinta dua dunia yang tak pernah saling mengerti.',
        'image':
            'https://images.unsplash.com/photo-1606112219348-204d7d8b94ee?auto=format&fit=crop&w=500&q=80',
      },
      {
        'title': 'Hujan di Ujung Senja',
        'author': 'Rizky Fajar',
        'description': 'Puisi kehidupan dan kehilangan yang abadi.',
        'image':
            'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=500&q=80',
      },
      {
        'title': 'Rembulan di Balik Awan',
        'author': 'Dewi Anggraini',
        'description': 'Perjalanan panjang mencari makna hidup.',
        'image':
            'https://images.unsplash.com/photo-1507842217343-583bb7270b66?auto=format&fit=crop&w=500&q=80',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 NovelKu'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: novels.length,
        itemBuilder: (context, index) {
          final novel = novels[index];
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
