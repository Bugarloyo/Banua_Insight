import 'package:banuainsight_project/data/models/news_model.dart';
import 'package:banuainsight_project/data/models/user_model.dart';
import 'package:banuainsight_project/data/services/auth_service.dart';
import 'package:banuainsight_project/data/services/news_service.dart';
import 'package:banuainsight_project/features/user/cari_berita_user.dart';
import 'package:banuainsight_project/features/user/detail_berita_user.dart';
import 'package:banuainsight_project/features/user/home_page_user.dart';
import 'package:banuainsight_project/features/user/profile_user.dart';
import 'package:banuainsight_project/features/user/riwayat_baca_user.dart';
import 'package:flutter/material.dart';

class SimpanUser extends StatefulWidget {
  const SimpanUser({super.key});

  @override
  State<SimpanUser> createState() => _SimpanUserState();
}

class _SimpanUserState extends State<SimpanUser> {
  final AuthService _authService = AuthService();
  final NewsService _newsService = NewsService();

  Future<void> _onItemTapped(BuildContext context, int index) async {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePageUser()),
      );
      return;
    }

    if (index == 1) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CariBeritaUser(selectedIndex: 1)),
      );
      return;
    }

    if (index == 2) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RiwayatBacaUser(selectedIndex: 2)),
      );
      return;
    }
  }

  Widget _buildNewsCard(BeritaModel berita) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailBeritaUser(berita: berita),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: berita.imgUrl.isEmpty
                  ? Image.asset(
                      'assets/img/download.jpg',
                      width: 86,
                      height: 86,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      berita.imgUrl,
                      width: 86,
                      height: 86,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/img/download.jpg',
                          width: 86,
                          height: 86,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    berita.judul,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    berita.deskripsi,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: FutureBuilder<UserModel?>(
        future: _authService.getCurrentUserData(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          return SingleChildScrollView(
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
                            'BANUA ',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 51, 96, 33),
                            ),
                          ),
                          const Text(
                            'INSIGHT',
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
                                builder: (context) => const ProfileUser(),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bookmarks',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Berita yang kamu simpan akan muncul di sini.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 18),
                      if (snapshot.connectionState == ConnectionState.waiting)
                        const Center(child: CircularProgressIndicator())
                      else if (user == null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFE9E3D5)),
                          ),
                          child: const Text('Belum ada user login aktif.'),
                        )
                      else
                        StreamBuilder<List<BeritaModel>>(
                          stream: _newsService.getBookmarkedBeritaStream(user.idUser),
                          builder: (context, bookmarkSnapshot) {
                            if (bookmarkSnapshot.connectionState == ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }

                            if (bookmarkSnapshot.hasError) {
                              return Text(
                                'Gagal memuat bookmarks: ${bookmarkSnapshot.error}',
                                style: const TextStyle(color: Colors.red),
                              );
                            }

                            final bookmarks = bookmarkSnapshot.data ?? [];
                            if (bookmarks.isEmpty) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: const Color(0xFFE9E3D5)),
                                ),
                                child: const Text('Belum ada berita yang disimpan.'),
                              );
                            }

                            return Column(
                              children: bookmarks.map(_buildNewsCard).toList(),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        ],
        currentIndex: 0,
        unselectedItemColor: Colors.amber[800],
        selectedItemColor: Colors.amber[800],
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}