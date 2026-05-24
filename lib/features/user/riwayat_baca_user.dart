import 'dart:convert';

import 'package:banuainsight_project/data/models/news_model.dart';
import 'package:banuainsight_project/data/models/user_model.dart';
import 'package:banuainsight_project/data/services/auth_service.dart';
import 'package:banuainsight_project/data/services/news_service.dart';
import 'package:banuainsight_project/features/user/cari_berita_user.dart';
import 'package:banuainsight_project/features/user/detail_berita_user.dart';
import 'package:banuainsight_project/features/user/home_page_user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatBacaUser extends StatefulWidget {
  final int selectedIndex;

  const RiwayatBacaUser({super.key, this.selectedIndex = 2});

  @override
  State<RiwayatBacaUser> createState() => _RiwayatBacaUserState();
}

class _RiwayatBacaUserState extends State<RiwayatBacaUser> {
  final AuthService _authService = AuthService();
  final NewsService _newsService = NewsService();
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  String _historyKey(int userId) => 'read_history_$userId';

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

    if (index == 2) return;
  }

  Future<List<_HistoryViewItem>> _loadHistory() async {
    final user = await _authService.getCurrentUserData();
    if (user == null) return [];

    final prefs = await SharedPreferences.getInstance();
    final rawHistory = prefs.getStringList(_historyKey(user.idUser)) ?? <String>[];
    final parsedHistory = <_HistoryEntry>[];

    for (final raw in rawHistory) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        parsedHistory.add(
          _HistoryEntry(
            idBerita: decoded['id_berita'] as int,
            openedAt: DateTime.tryParse(decoded['opened_at']?.toString() ?? '') ?? DateTime.now(),
          ),
        );
      } catch (_) {
        continue;
      }
    }

    final items = <_HistoryViewItem>[];
    for (final entry in parsedHistory) {
      final berita = await _newsService.getBeritaById(entry.idBerita);
      if (berita != null) {
        items.add(_HistoryViewItem(berita: berita, openedAt: entry.openedAt));
      }
    }
    return items;
  }

  Widget _buildHistoryCard(_HistoryViewItem item) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailBeritaUser(berita: item.berita),
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
              child: item.berita.imgUrl.isEmpty
                  ? Image.asset(
                      'assets/img/download.jpg',
                      width: 86,
                      height: 86,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      item.berita.imgUrl,
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
                    item.berita.judul,
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
                    item.berita.deskripsi,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dibuka ${DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(item.openedAt)}',
                    style: const TextStyle(fontSize: 11, color: Colors.black45),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<UserModel?>(
        future: _authService.getCurrentUserData(),
        builder: (context, snapshot) {
          final user = snapshot.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePageUser(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(
                          Icons.arrow_back,
                          color: Color(0xFF2B2B2B),
                          size: 24,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Riwayat Baca',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B2B2B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Daftar berita yang pernah kamu buka akan tampil di sini.',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
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
                  FutureBuilder<List<_HistoryViewItem>>(
                    future: _loadHistory(),
                    builder: (context, historySnapshot) {
                      if (historySnapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (historySnapshot.hasError) {
                        return Text(
                          'Gagal memuat riwayat baca: ${historySnapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        );
                      }

                      final items = historySnapshot.data ?? [];
                      if (items.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFE9E3D5)),
                          ),
                          child: const Text('Belum ada riwayat baca.'),
                        );
                      }

                      return Column(
                        children: items.map(_buildHistoryCard).toList(),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.amber[800],
        selectedItemColor: Colors.amber[800],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        ],
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}

class _HistoryEntry {
  final int idBerita;
  final DateTime openedAt;

  const _HistoryEntry({required this.idBerita, required this.openedAt});
}

class _HistoryViewItem {
  final BeritaModel berita;
  final DateTime openedAt;

  const _HistoryViewItem({required this.berita, required this.openedAt});
}