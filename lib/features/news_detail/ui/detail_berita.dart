import 'package:banuainsight_project/features/search_news/cari_berita.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:banuainsight_project/features/add_news/tambah_berita.dart';
import 'package:banuainsight_project/data/models/user_model.dart';
import 'package:banuainsight_project/data/models/news_model.dart';
import 'package:banuainsight_project/data/services/auth_service.dart';
import 'package:banuainsight_project/data/services/news_service.dart';
import 'edit_berita.dart';
import 'hapus_berita.dart';

class DetailBerita extends StatefulWidget {
  final BeritaModel berita;

  const DetailBerita({super.key, required this.berita});

  @override
  State<DetailBerita> createState() => _DetailBeritaState();
}

class _DetailBeritaState extends State<DetailBerita> {
  bool isLiked = false;
  bool isSaved = false;
  bool _isLoadingAction = false;
  final NewsService _newsService = NewsService();
  final AuthService _authService = AuthService();
  UserModel? _currentUser;

  // Variabel dan fungsi untuk BottomNavigationBar
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadInteractionState();
  }

  Future<void> _loadInteractionState() async {
    final user = await _authService.getCurrentUserData();
    if (!mounted) return;

    if (user == null) {
      setState(() {
        _currentUser = null;
      });
      return;
    }

    final liked = await _newsService.isBeritaLiked(
      user.idUser,
      widget.berita.idBerita,
    );
    final bookmarked = await _newsService.isBeritaBookmarked(
      user.idUser,
      widget.berita.idBerita,
    );

    if (!mounted) return;
    setState(() {
      _currentUser = user;
      isLiked = liked;
      isSaved = bookmarked;
    });
  }

  void _onItemTapped(int index) {
    // Index 0: Beranda (kembali ke route pertama)
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CariBerita()),
      );
      return;
    }

    // Index 2: Tambah (buka halaman tambah berita)
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TambahBerita()),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleMoreAction(String action) async {
    if (action == 'edit') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditBerita(berita: widget.berita),
        ),
      );
    } else if (action == 'hapus') {
      await handleHapusBeritaWithAlert(
        context,
        onDelete: () async {
          await _newsService.deleteBerita(widget.berita.idBerita);
        },
      );
    }
  }

  Future<void> _toggleLike() async {
    if (_currentUser == null) return;

    setState(() {
      _isLoadingAction = true;
    });

    try {
      await _newsService.toggleLikeBerita(
        _currentUser!.idUser,
        widget.berita.idBerita,
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
        widget.berita.idBerita,
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
            Text(
              widget.berita.judul,
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
                Text(
                  _formatDate(widget.berita.createdAt.toDate()),
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
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
                                CupertinoIcons.delete,
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
              child: widget.berita.imgUrl.isEmpty
                  ? Image.asset(
                      'assets/img/download.jpg',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      widget.berita.imgUrl,
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
            const SizedBox(height: 12),
            Text(
              widget.berita.namaAdmin.isEmpty
                  ? 'Di upload oleh admin'
                  : 'Di upload oleh ${widget.berita.namaAdmin} (ID: ${widget.berita.idUserAdmin})',
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Text(
              widget.berita.isiKonten,
              textAlign: TextAlign.justify,
              style: const TextStyle(
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, weight: 600),
            label: 'Tambah',
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
