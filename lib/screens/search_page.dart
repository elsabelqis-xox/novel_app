import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/book_service.dart';
import '../models/bookshelf_model.dart';
import '../models/favorite_model.dart';
import '../widgets/book_card.dart';

class BookSearchDelegate extends SearchDelegate<String> {
  final List<String> _history = [
    'Flutter',
    'Programming',
    'Science Fiction',
    'Fantasy',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return const Center(child: Text('Ketik sesuatu untuk mencari.'));
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: BookService.searchBooks(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gagal memuat hasil: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      buildResults(context);
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada buku ditemukan.'));
        } else {
          final List<Map<String, dynamic>> books = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(book: book);
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList =
        query.isEmpty
            ? _history
            : _history
                .where(
                  (element) =>
                      element.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final String suggestion = suggestionList[index];
        return ListTile(
          leading: const Icon(Icons.history),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}
