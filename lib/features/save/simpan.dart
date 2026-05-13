import 'package:banuainsight_project/features/add_news/tambah_berita.dart';
import 'package:banuainsight_project/features/search_news/cari_berita.dart';
import 'package:banuainsight_project/features/profile/profile.dart';
import 'package:flutter/material.dart';

class Simpan extends StatelessWidget {
  const Simpan({super.key});

  Future<void> _onItemTapped(BuildContext context, int index) async {
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
      return;
    }

    if (index == 2) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TambahBerita()),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "BANUA ",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 51, 96, 33),
                        ),
                      ),
                      const Text(
                        "INSIGHT",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 230, 141, 58),
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(Icons.person, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Profile(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.grey, thickness: 1, height: 2),
          ],
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
        selectedItemColor:Colors.amber[800],
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
