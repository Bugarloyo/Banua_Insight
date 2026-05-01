import 'package:flutter/material.dart';

class EditBerita extends StatefulWidget {
  const EditBerita({super.key});

  @override
  State<EditBerita> createState() => _EditBeritaState();
}

class _EditBeritaState extends State<EditBerita> {
  late TextEditingController judulController;
  late TextEditingController isiController;
  String imageUrl = 'https://example.com/image.jpg';

  @override
  void initState() {
    super.initState();
    judulController = TextEditingController(
      text: 'Polres Banjarbaru Selidiki Kecelakaan Maut Libatkan Mobil Polisi',
    );
    isiController = TextEditingController(
      text:
          'Satuan Lalu Lintas Polres Banjarbaru tengah menyelidiki kecelakaan maut yang terjadi di Jalan Ahmad Yani Kilometer 21, Minggu pagi, 27 Juli 2025.\n\n'
          'Peristiwa tersebut melibatkan sepeda motor yang dikendarai seorang pelajar dengan mobil operasional milik Dit Samapta Polda Kalimantan Selatan.\n\n'
          'Korban, Iqbal Risanta, siswa SMKN di Gambut, Kabupaten Banjar, tewas di tempat.',
    );
  }

  @override
  void dispose() {
    judulController.dispose();
    isiController.dispose();
    super.dispose();
  }

  void _handleEditGambar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur edit gambar akan segera hadir')),
    );
  }

  void _handleSimpanBerita() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Berita berhasil disimpan')));
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
              maxLines: 3,
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
                  imageUrl,
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
                onPressed: _handleSimpanBerita,
                icon: const Icon(Icons.check),
                label: const Text('Simpan Berita'),
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
