import 'package:flutter/material.dart';

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
          ],
        ),
      ),
    );
  }
}
