import 'package:flutter/material.dart';
import 'package:banuainsight_project/data/models/news_model.dart';
import 'package:banuainsight_project/data/services/news_service.dart';

class EditBerita extends StatefulWidget {
  final BeritaModel berita;

  const EditBerita({super.key, required this.berita});

  @override
  State<EditBerita> createState() => _EditBeritaState();
}

class _EditBeritaState extends State<EditBerita> {
  late final TextEditingController judulController;
  late final TextEditingController deskripsiController;
  late final TextEditingController isiController;
  late final TextEditingController imageUrlController;
  final NewsService _newsService = NewsService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    judulController = TextEditingController(text: widget.berita.judul);
    deskripsiController = TextEditingController(text: widget.berita.deskripsi);
    isiController = TextEditingController(text: widget.berita.isiKonten);
    imageUrlController = TextEditingController(text: widget.berita.imgUrl);
  }

  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    isiController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  void _handleEditGambar() {
    _showImageUrlDialog();
  }

  Future<void> _showImageUrlDialog() async {
    final imageUrlEditController = TextEditingController(text: imageUrlController.text);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Edit URL Gambar'),
          content: TextField(
            controller: imageUrlEditController,
            decoration: const InputDecoration(
              hintText: 'Masukkan URL gambar',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 76, 175, 80)),
              onPressed: () {
                setState(() {
                  imageUrlController.text = imageUrlEditController.text.trim();
                });
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
    imageUrlEditController.dispose();
  }

  Future<void> _handleSimpanBerita() async {
    // Cegah multiple clicks
    if (_isSaving) return;

    if (!mounted) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _newsService.editBerita(
        idBerita: widget.berita.idBerita,
        judul: judulController.text.trim(),
        deskripsi: deskripsiController.text.trim(),
        isiKonten: isiController.text.trim(),
        imgUrl: imageUrlController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berita berhasil disimpan')),
      );

      // Tunggu frame rendering selesai sebelum pop
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pop(context, true);
        }
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan berita: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 120,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Row(
            children: [
              SizedBox(width: 15),
              Icon(Icons.arrow_back, color: Colors.black, size: 24),
              SizedBox(width: 5),
              Text(
                'Kembali',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Input
            const Text(
              'Judul Berita',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: judulController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Masukkan judul berita',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 51, 96, 33),
                    width: 2,
                  ),
                ),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Isi Berita Input
            const Text(
              'Isi Berita',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: isiController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Masukkan isi berita',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 51, 96, 33),
                    width: 2,
                  ),
                ),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Gambar Section
            const Text(
              'Gambar Berita',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: 220,
                color: Colors.grey[300],
                child: Image.network(
                  imageUrlController.text,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gambar tidak tersedia',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _handleEditGambar,
                icon: const Icon(Icons.image),
                label: const Text('Edit Gambar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _handleSimpanBerita,
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.check),
                label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Berita'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
