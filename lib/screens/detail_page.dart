// lib/screens/detail_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/book_service.dart'; // Pastikan path ini benar

class DetailPage extends StatefulWidget {
  final String title;
  final String author;
  final String? description;
  final String? imageUrl;
  final String? olid;
  final String? openLibraryUrl;

  const DetailPage({
    super.key,
    required this.title,
    required this.author,
    this.description, // Tidak pakai required karena String?
    this.imageUrl, // Tidak pakai required karena String?
    this.olid,
    this.openLibraryUrl, // Tidak pakai required karena String?
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? _description;
  bool _loadingDescription = false;

  @override
  void initState() {
    super.initState();
    _description = widget.description ?? 'Deskripsi tidak tersedia.';

    if (widget.olid != null && widget.olid!.isNotEmpty) {
      final currentDescription = widget.description;
      if (currentDescription == null ||
          currentDescription.trim().isEmpty ||
          currentDescription.trim().split(' ').length < 100 ||
          currentDescription == 'Deskripsi tidak tersedia.') {
        // Tambahkan ini jika string default-nya juga ingin di-fetch
        _fetchDescriptionByOLID(widget.olid!);
      }
    }
  }

  Future<void> _fetchDescriptionByOLID(String olid) async {
    setState(() => _loadingDescription = true);
    try {
      final cleanedOlid =
          olid.startsWith('/works/') ? olid.substring('/works/'.length) : olid;
      final data = await BookService.fetchDetailByOLID(cleanedOlid);
      final dynamic desc = data['description'];

      if (mounted) {
        setState(() {
          String? newDescription;
          if (desc is Map) {
            newDescription = desc['value']?.toString();
          } else {
            newDescription = desc?.toString();
          }

          _description =
              newDescription?.trim().isNotEmpty == true
                  ? newDescription
                  : widget.description ?? 'Deskripsi tidak tersedia.';

          _loadingDescription = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingDescription = false;
          _description =
              (widget.description?.isNotEmpty == true)
                  ? widget.description
                  : 'Deskripsi gagal dimuat.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat deskripsi lengkap: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.imageUrl ??
                    'https://via.placeholder.com/200x300.png?text=No+Image',
                fit: BoxFit.cover,
                height: 250,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.book,
                        size: 100,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Penulis: ${widget.author}',
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            _loadingDescription
                ? const Center(child: CircularProgressIndicator())
                : Text(
                  _description ?? 'Deskripsi tidak tersedia.',
                  style: const TextStyle(fontSize: 16),
                ),
            const SizedBox(height: 20),
            if (widget.openLibraryUrl?.isNotEmpty == true)
              ElevatedButton(
                onPressed: () async {
                  final url = Uri.parse(widget.openLibraryUrl!);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Tidak dapat membuka URL: ${widget.openLibraryUrl}',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Lihat di Open Library'),
              ),
          ],
        ),
      ),
    );
  }
}
