// lib/screens/detail_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/book_service.dart';

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
    this.description,
    this.imageUrl,
    this.olid,
    this.openLibraryUrl,
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
    _description = widget.description;

    if (widget.olid != null && widget.olid!.isNotEmpty) {
      final currentDescription = widget.description;
      if (currentDescription == null ||
          currentDescription.trim().isEmpty ||
          (currentDescription.trim().split(' ').length < 100 &&
              currentDescription != 'Deskripsi tidak tersedia.') ||
          currentDescription == 'Deskripsi tidak tersedia.') {
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
                  : 'Deskripsi gagal dimuat. Coba lagi nanti.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat deskripsi lengkap: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  widget.imageUrl ??
                      'https://via.placeholder.com/200x300.png?text=No+Image',
                  fit: BoxFit.cover,
                  height: 250,
                  width: 170,

                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 250,
                      width: 170,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                          strokeWidth: 3.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  },

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      width: 170,
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
            ),
            const SizedBox(height: 24),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Penulis: ${widget.author}',
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Deskripsi:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            _loadingDescription
                ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: CircularProgressIndicator(),
                  ),
                )
                : Text(
                  _description ?? 'Deskripsi tidak tersedia.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.justify,
                ),
            const SizedBox(height: 30),
            if (widget.openLibraryUrl?.isNotEmpty == true)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(widget.openLibraryUrl!);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Tidak dapat membuka URL: ${widget.openLibraryUrl}',
                          ),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.link),
                  label: const Text(
                    'Lihat di Open Library',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
