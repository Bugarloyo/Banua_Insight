import 'dart:convert';

import 'package:banuainsight_project/data/models/news_model.dart';
import 'package:banuainsight_project/data/models/user_model.dart';
import 'package:banuainsight_project/data/services/auth_service.dart';
import 'package:banuainsight_project/data/services/news_service.dart';
import 'package:banuainsight_project/features/user/cari_berita_user.dart';
import 'package:banuainsight_project/features/user/riwayat_baca_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailBeritaUser extends StatefulWidget {
  final BeritaModel berita;

  const DetailBeritaUser({super.key, required this.berita});

  @override
  State<DetailBeritaUser> createState() => _DetailBeritaUserState();
}

class _DetailBeritaUserState extends State<DetailBeritaUser> {
  late BeritaModel _berita;
  bool isLiked = false;
  bool isSaved = false;
  bool _isLoadingAction = false;
  final NewsService _newsService = NewsService();
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _berita = widget.berita;
    _loadInteractionState();
    _recordReadHistory();
  }

  Future<void> _recordReadHistory() async {
    final user = await _authService.getCurrentUserData();
    if (!mounted || user == null) return;

    final prefs = await SharedPreferences.getInstance();
    final key = _historyKey(user.idUser);
    final rawHistory = prefs.getStringList(key) ?? <String>[];
    rawHistory.removeWhere((entry) {
      try {
        final decoded = jsonDecode(entry) as Map<String, dynamic>;
        return decoded['id_berita'] == _berita.idBerita;
      } catch (_) {
        return false;
      }
    });

    rawHistory.insert(
      0,
      jsonEncode({
        'id_berita': _berita.idBerita,
        'opened_at': DateTime.now().toIso8601String(),
      }),
    );

    if (rawHistory.length > 30) {
      rawHistory.removeRange(30, rawHistory.length);
    }

    await prefs.setStringList(key, rawHistory);
  }

  String _historyKey(int userId) => 'read_history_$userId';

  Future<void> _loadInteractionState() async {
    final user = await _authService.getCurrentUserData();
    if (!mounted) return;

    if (user == null) {
      setState(() {
        _currentUser = null;
      });
      return;
    }

    final liked = await _newsService.isBeritaLiked(user.idUser, _berita.idBerita);
    final bookmarked = await _newsService.isBeritaBookmarked(
      user.idUser,
      _berita.idBerita,
    );

    if (!mounted) return;
    setState(() {
      _currentUser = user;
      isLiked = liked;
      isSaved = bookmarked;
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CariBeritaUser()),
      );
      return;
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RiwayatBacaUser()),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _toggleLike() async {
    if (_currentUser == null) return;

    setState(() {
      _isLoadingAction = true;
    });

    try {
      await _newsService.toggleLikeBerita(
        _currentUser!.idUser,
        _berita.idBerita,
      );
      if (!mounted) return;
      setState(() {
        isLiked = !isLiked;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAction = false;
        });
      }
    }
  }

  Future<void> _toggleBookmark() async {
    if (_currentUser == null) return;

    setState(() {
      _isLoadingAction = true;
    });

    try {
      await _newsService.toggleBookmarkBerita(
        _currentUser!.idUser,
        _berita.idBerita,
      );
      if (!mounted) return;
      setState(() {
        isSaved = !isSaved;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAction = false;
        });
      }
    }
  }

  String _sanitizeIsi(String s) {
    if (s.isEmpty) return s;
    var t = s.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    t = t.replaceAll(RegExp(r'<[^>]*>'), ' ');
    t = t.replaceAll('&nbsp;', ' ').replaceAll('\u00A0', ' ');
    t = t.replaceAll(RegExp(r'\n{2,}'), '\n');
    t = t.replaceAll(RegExp(r'[ \t]{2,}'), ' ');
    t = t.trim();
    return t;
  }

  String _formatDate(DateTime dateTime) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 120,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
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
            Text(
              _berita.judul,
              style: const TextStyle(
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
                Text(
                  _formatDate(_berita.createdAt.toDate()),
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _isLoadingAction ? null : _toggleLike,
                      child: Icon(
                        isLiked ? Icons.thumb_up : Icons.thumb_up_alt_rounded,
                        size: 24,
                        color: isLiked ? Colors.blue : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: _isLoadingAction ? null : _toggleBookmark,
                      child: Icon(
                        CupertinoIcons.bookmark_fill,
                        size: 24,
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
              child: _berita.imgUrl.isEmpty
                  ? Image.asset(
                      'assets/img/download.jpg',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      _berita.imgUrl,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/img/download.jpg',
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              _berita.namaAdmin.isEmpty
                  ? 'Di upload oleh admin'
                  : 'Di upload oleh ${_berita.namaAdmin}',
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              _sanitizeIsi(_berita.isiKonten),
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
     bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, weight: 600),
            label: 'Riwayat',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.amber[800],
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}