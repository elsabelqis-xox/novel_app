import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/book_service.dart';
import '../models/bookshelf_model.dart'; // Diperlukan untuk BookCard
import '../models/favorite_model.dart'; // Diperlukan untuk BookCard
import '../widgets/book_card.dart'; // Import BookCard yang sudah dipindahkan

class BookSearchDelegate extends SearchDelegate<String> {
  // Riwayat pencarian (opsional, bisa disimpan di SharedPreferences)
  final List<String> _history = [
    'Flutter',
    'Programming',
    'Science Fiction',
    'Fantasy',
  ];

  // Metode ini dipanggil untuk membangun tindakan di AppBar pencarian (misal: tombol hapus)
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Hapus teks pencarian
          showSuggestions(context); // Tampilkan saran lagi
        },
      ),
    ];
  }

  // Metode ini dipanggil untuk membangun tombol kembali di AppBar pencarian
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, ''); // Tutup halaman pencarian
      },
    );
  }

  // Metode ini dipanggil ketika pengguna menekan tombol 'search' di keyboard
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
                      // Ini sedikit rumit karena kita tidak punya State untuk panggil setState
                      // Solusi terbaik adalah menutup dan membuka kembali pencarian, atau
                      // membiarkan pengguna mengetik ulang. Untuk demo, ini sederhana:
                      // Kamu bisa menambahkan logika retry yang lebih canggih jika diperlukan.
                      buildResults(
                        context,
                      ); // Meminta buildResults untuk dibangun ulang (tidak ideal untuk retry API)
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
              return BookCard(book: book); // Gunakan BookCard yang diimpor
            },
          );
        }
      },
    );
  }

  // Metode ini dipanggil untuk membangun saran saat pengguna mengetik
  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList =
        query.isEmpty
            ? _history // Tampilkan riwayat jika query kosong
            : _history
                .where(
                  (element) =>
                      element.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
    // Atau kamu bisa memanggil API untuk saran real-time jika diperlukan

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final String suggestion = suggestionList[index];
        return ListTile(
          leading: const Icon(Icons.history), // Atau Icon(Icons.search)
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: TextStyle(
                color:
                    Theme.of(
                      context,
                    ).colorScheme.primary, // Sesuaikan warna dengan tema
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: TextStyle(
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.onSurface, // Sesuaikan warna dengan tema
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            query = suggestion; // Set teks pencarian ke saran yang dipilih
            showResults(context); // Tampilkan hasil pencarian
          },
        );
      },
    );
  }
}
