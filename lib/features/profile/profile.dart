import 'package:banuainsight_project/features/add_news/tambah_berita.dart';
import 'package:banuainsight_project/features/search_news/cari_berita.dart';
import 'package:banuainsight_project/features/save/simpan.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  Future<void> _onItemTapped(BuildContext context, int index) async {
    if (index == 0) {
      Navigator.pop(context);
      return;
    }

    if (index == 1) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CariBerita(selectedIndex: 1),
        ),
      );
      return;
    }

    if (index == 2) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TambahBerita()),
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
      body: Center(
        child: Transform.translate(
          offset: const Offset(0, -200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 55,
                child: const Icon(Icons.person, color: Colors.white, size: 60),
              ),
              const SizedBox(height: 8),
              const Text(
                'Admin',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 350,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Simpan()),
                    );
                  },
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text('Tersimpan'),
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
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Aksi ketika tombol ditekan, misalnya keluar dari akun
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text('Keluar'),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, weight: 600),
            label: 'Tambah',
          ),
        ],
        currentIndex: 0,
        unselectedItemColor: Colors.amber[800],
        selectedItemColor: const Color.fromARGB(255, 51, 96, 33),
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
