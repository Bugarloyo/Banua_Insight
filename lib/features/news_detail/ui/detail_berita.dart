import 'package:flutter/material.dart';

class DetailBerita extends StatefulWidget {
  const DetailBerita({super.key});

  @override
  State<DetailBerita> createState() => _DetailBeritaState();
}

class _DetailBeritaState extends State<DetailBerita> {
  bool isLiked = false;
  bool isSaved = false;

  // Variabel dan fungsi untuk BottomNavigationBar
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleMoreAction(String action) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Aksi $action dipilih')));
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
            const SizedBox(height: 10),
            const Text(
              'Polres Banjarbaru Selidiki Kecelakaan Maut Libatkan Mobil Polisi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '27 Juli 2025',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'di upload oleh admin',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 15),
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      color: Colors.white,
                      elevation: 10,
                      offset: const Offset(0, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onSelected: _handleMoreAction,
                      itemBuilder: (context) => [
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 22,
                                color: Colors.black,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'hapus',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                size: 22,
                                color: Colors.black,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Hapus',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.more_horiz,
                          size: 36,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () => setState(() => isLiked = !isLiked),
                      child: Icon(
                        isLiked ? Icons.thumb_up : Icons.thumb_up_alt_rounded,
                        size: 24,
                        color: isLiked ? Colors.blue : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () => setState(() => isSaved = !isSaved),
                      child: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark,
                        size: 26,
                        color: isSaved ? Colors.orange : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://example.com/image.jpg',
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Satuan Lalu Lintas Polres Banjarbaru tengah menyelidiki kecelakaan maut yang terjadi di Jalan Ahmad Yani Kilometer 21, Minggu pagi, 27 Juli 2025.\n\n'
              'Peristiwa tersebut melibatkan sepeda motor yang dikendarai seorang pelajar dengan mobil operasional milik Dit Samapta Polda Kalimantan Selatan.\n\n'
              'Korban, Iqbal Risanta, siswa SMKN di Gambut, Kabupaten Banjar, tewas di tempat.\n\n'
              'Lokasi kecelakaan hanya berjarak sekitar 100 meter dari rumah korban di Gang Permata RT 05 RW 01, Kecamatan Liang Anggang.\n\n'
              'Kepala Satuan Lalu Lintas Polres Banjarbaru, AKP Embang Pramono, mengatakan pihaknya bersama Direktorat Lalu Lintas Polda Kalsel telah melakukan olah tempat kejadian perkara.\n\n'
              '"Penyelidikan masih berlangsung. Kami memeriksa pengemudi mobil dinas dan sejumlah saksi di lokasi kejadian," ujar Embang.\n\n'
              'Dari keterangan keluarga, Iqbal diketahui baru belajar mengendarai motor.\n\n'
              'Saat kecelakaan, ia tidak mengenakan helm dan belum memiliki Surat Izin Mengemudi (SIM).',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, weight: 600),
            label: 'Tambah',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.amber[800],
        selectedItemColor: Color.fromARGB(255, 51, 96, 33),
        onTap: _onItemTapped,
      ),
    );
  }
}
