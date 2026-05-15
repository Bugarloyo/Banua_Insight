import 'package:banuainsight_project/data/services/news_service.dart';
import 'package:banuainsight_project/data/services/auth_service.dart';
import 'package:banuainsight_project/data/models/user_model.dart';
import 'package:banuainsight_project/features/search_news/cari_berita.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class TambahBerita extends StatefulWidget {
  const TambahBerita({super.key});

  @override
  State<TambahBerita> createState() => _TambahBeritaState();
}

class _TambahBeritaState extends State<TambahBerita> {
  final _formKey = GlobalKey<FormState>();
  final NewsService _newsService = NewsService();
  final AuthService _authService = AuthService();

  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiKontenController = TextEditingController();
  final TextEditingController _imgUrlController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _judulController.dispose();
    _isiKontenController.dispose();
    _imgUrlController.dispose();
    super.dispose();
  }

  Future<void> _onNavbarTapped(int index) async {
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    if (index == 1) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CariBerita(selectedIndex: 1),
        ),
      );
    }
  }

  Future<void> _simpanBerita() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_imgUrlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan upload gambar dulu')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final UserModel? currentUser = await _authService.getCurrentUserData();
      if (currentUser == null || currentUser.role.toLowerCase() != 'admin') {
        throw 'Data admin tidak ditemukan';
      }

      await _newsService.addBerita(
        judul: _judulController.text.trim(),
        deskripsi: _isiKontenController.text.trim(),
        isiKonten: _isiKontenController.text.trim(),
        imgUrl: _imgUrlController.text.trim(),
        idUserAdmin: currentUser.idUser,
        namaAdmin: currentUser.nama,
      );

      if (!mounted) {
        return;
      }

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
                'Berita berhasil ditambah',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 79, 152, 43),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan berita: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showImageUrlDialog() async {
    final imageUrlController = TextEditingController(
      text: _imgUrlController.text,
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Upload Gambar'),
          content: TextField(
            controller: imageUrlController,
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 79, 152, 43),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _imgUrlController.text = imageUrlController.text.trim();
                });
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    imageUrlController.dispose();
  }

  Widget _buildTextInput({
    required String hintText,
    required TextEditingController controller,
    required String validatorMessage,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return validatorMessage;
          }
          return null;
        },
      ),
    );
  }

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

  Future<void> _getScrapingData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await get(
        Uri.parse('https://redkal.com/wp-json/wp/v2/posts?per_page=20'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          // final firstPost = data[0];
          for (var i = 0; i < data.length; i++) {
            print('proses data ke-${data.length}');
            print('proses data ke-${i}');
            if (i < 10) {
              print('data ke-${i} diproses');
            } else {
              final String rawTitle = data[i]['title']['rendered'] ?? '';
              final String rawContent = data[i]['content']['rendered'] ?? '';
              final String urlImage =
                  data[i]['yoast_head_json']['og_image'][0]['url'] ?? '';

              // Basic HTML tag removal
              final String cleanTitle = rawTitle.replaceAll(
                RegExp(r'<[^>]*>|&#\d+;'),
                '',
              );
              final String cleanContent = rawContent.replaceAll(
                RegExp(r'<[^>]*>|&#\d+;'),
                '',
              );

              sendDataAPIToDb(
                title: cleanTitle,
                content: cleanContent,
                imageUrl: urlImage,
              );
            }
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data berhasil diambil')),
              );
            }
          }
        }
      } else {
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 42, 125, 210),
        elevation: 0,
        toolbarHeight: 4,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Isi Judul',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextInput(
                hintText: 'Masukkan Judul',
                controller: _judulController,
                validatorMessage: 'Judul berita wajib diisi',
              ),
              const SizedBox(height: 18),
              const Text(
                'Isi Berita',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextInput(
                hintText: 'Masukkan Isi Berita',
                controller: _isiKontenController,
                validatorMessage: 'Isi berita wajib diisi',
                maxLines: 4,
              ),
              const SizedBox(height: 34),
              _buildGreenButton(
                label: 'Upload Gambar',
                icon: Icons.photo_camera_outlined,
                onPressed: _showImageUrlDialog,
              ),
              const SizedBox(height: 14),
              _buildGreenButton(
                label: _isLoading ? 'Menyimpan...' : 'Upload Berita',
                icon: _isLoading
                    ? Icons.cloud_upload_outlined
                    : Icons.cloud_upload_outlined,
                onPressed: _isLoading ? null : _simpanBerita,
              ),
              const SizedBox(height: 14),
              _buildGreenButton(
                label: 'tambah data scraping',
                icon: _isLoading
                    ? Icons.cloud_upload_outlined
                    : Icons.cloud_upload_outlined,
                onPressed: _getScrapingData,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: 2,
        selectedItemColor: const Color.fromARGB(255, 51, 96, 33),
        unselectedItemColor: const Color.fromARGB(255, 230, 141, 58),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Tambah'),
        ],
        onTap: _onNavbarTapped,
      ),
    );
  }
}

void sendDataAPIToDb({
  required String title,
  required String content,
  required String imageUrl,
}) {
  print('data yang dikirim ke API:');
  print('Title: $title');
  final authService = AuthService();
  authService.getCurrentUserData().then((currentUser) {
    if (currentUser == null || currentUser.role.toLowerCase() != 'admin') {
      throw 'Data admin tidak ditemukan';
    }
    return NewsService().addBerita(
      judul: title,
      deskripsi: content,
      isiKonten: content,
      imgUrl: imageUrl,
      idUserAdmin: currentUser.idUser,
      namaAdmin: currentUser.nama,
    );
  });
}
