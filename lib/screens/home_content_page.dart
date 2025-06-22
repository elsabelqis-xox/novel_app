import 'package:flutter/material.dart';
import '../services/book_service.dart';
import '../widgets/book_card.dart';
import 'detail_page.dart';
import 'search_page.dart';

class HomeContentPage extends StatefulWidget {
  const HomeContentPage({Key? key}) : super(key: key);

  @override
  State<HomeContentPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  List<Map<String, dynamic>> _popularNovels = [];
  List<Map<String, dynamic>> _latestNovels = [];
  List<Map<String, dynamic>> _recommendedNovels = [];

  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchBookData();
  }

  // --- Ini yang perlu ditambahkan: Fungsi dispose() ---
  @override
  void dispose() {
    // Jika kamu punya timer atau listener yang terus berjalan,
    // di sinilah tempat untuk membatalkannya.
    // Saat ini, _fetchBookData() adalah Future, jadi tidak perlu pembatalan eksplisit
    // kecuali kamu menggunakan CancelableOperation package.
    super.dispose();
  }
  // --- Akhir dari penambahan ---

  Future<void> _fetchBookData() async {
    // PENTING: Periksa `mounted` sebelum memanggil setState() pertama kali di sini
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      _popularNovels = await BookService.fetchTrendingBooks();
      _latestNovels = await BookService.searchBooks('novel');
      _recommendedNovels = await BookService.searchBooks('fiction fantasy');

      // PENTING: Periksa `mounted` sebelum memanggil setState() setelah Future selesai
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // PENTING: Periksa `mounted` sebelum memanggil setState() di blok catch
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat data buku: $e';
        });
      }
      print('Error fetching book data: $e');
    }
  }

  Widget _buildBookList(List<Map<String, dynamic>> books) {
    if (books.isEmpty) {
      return const Center(
        child: Text('Tidak ada buku yang tersedia di kategori ini.'),
      );
    }
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => DetailPage(
                          title: book['title']!,
                          author: book['author']!,
                          description: book['description']!,
                          imageUrl:
                              book['imageUrl'] ??
                              'https://via.placeholder.com/150x200?text=No+Cover',
                          olid: book['olid'],
                          openLibraryUrl: book['openLibraryUrl'],
                        ),
                  ),
                );
              },
              child: SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        book['imageUrl'] ??
                            'https://via.placeholder.com/150x200?text=No+Cover',
                        height: 180,
                        width: 150,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 180,
                            width: 150,
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 180,
                            width: 150,
                            color: Colors.grey[200],
                            child: Center(
                              child: Icon(
                                Icons.book,
                                size: 50,
                                color: Colors.grey[400],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      book['title']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      book['author']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Library Books📚'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: BookSearchDelegate());
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage, textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchBookData,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Novel Populer'),
                      _buildBookList(_popularNovels),
                      const SizedBox(height: 24),
                      _buildSectionHeader('Novel Terbaru'),
                      _buildBookList(_latestNovels),
                      const SizedBox(height: 24),
                      _buildSectionHeader('Novel Rekomendasi'),
                      _buildBookList(_recommendedNovels),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
