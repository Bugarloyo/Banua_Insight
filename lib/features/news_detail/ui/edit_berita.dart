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

  Widget _buildGreenButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 34,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 79, 152, 43),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
        ),
      ),
    );
  }

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
    final newImageUrl = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return _ImageUrlDialog(initialValue: imageUrlController.text);
      },
    );

    if (newImageUrl != null && mounted) {
      setState(() {
        imageUrlController.text = newImageUrl;
      });
    }
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

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 60),
              SizedBox(height: 12),
              Text(
                'Berita berhasil disimpan',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop(true);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
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
            _buildGreenButton(
              label: 'Edit Gambar',
              icon: Icons.photo_camera_outlined,
              onPressed: _handleEditGambar,
            ),
            const SizedBox(height: 12),
            _buildGreenButton(
              label: _isSaving ? 'Menyimpan...' : 'Simpan Berita',
              icon: Icons.cloud_upload_outlined,
              onPressed: _isSaving ? null : _handleSimpanBerita,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ImageUrlDialog extends StatefulWidget {
  final String initialValue;

  const _ImageUrlDialog({required this.initialValue});

  @override
  State<_ImageUrlDialog> createState() => _ImageUrlDialogState();
}

class _ImageUrlDialogState extends State<_ImageUrlDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text('Edit URL Gambar'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Masukkan URL gambar',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 76, 175, 80)),
          onPressed: () {
            Navigator.of(context).pop(_controller.text.trim());
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
