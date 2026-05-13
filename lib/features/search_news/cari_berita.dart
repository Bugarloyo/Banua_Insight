import 'package:banuainsight_project/data/models/news_model.dart';
import 'package:banuainsight_project/data/services/news_service.dart';
import 'package:banuainsight_project/features/add_news/tambah_berita.dart';
import 'package:banuainsight_project/features/news_detail/ui/detail_berita.dart';
import 'package:flutter/material.dart';

class CariBerita extends StatefulWidget {
  final int selectedIndex;

  const CariBerita({super.key, this.selectedIndex = 1});

  @override
  State<CariBerita> createState() => _CariBeritaState();
}

class _CariBeritaState extends State<CariBerita> {
  final TextEditingController _searchController = TextEditingController();
  final NewsService _newsService = NewsService();
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesQuery(BeritaModel berita, String query) {
    if (query.isEmpty) {
      return true;
    }

    final lowerQuery = query.toLowerCase();
    return berita.judul.toLowerCase().contains(lowerQuery) ||
        berita.deskripsi.toLowerCase().contains(lowerQuery) ||
        berita.isiKonten.toLowerCase().contains(lowerQuery);
  }

  void _openDetailBerita(BeritaModel berita) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailBerita(berita: berita)),
    );
  }

  Future<void> _onItemTapped(BuildContext context, int index) async {
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    if (index == 1) {
      return;
    }

    if (index == 2) {
      await Navigator.pushReplacement(
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
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
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
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: "cari berita yang anda ingin kan",
                      hintStyle: const TextStyle(
                        color: Color(0xFFB7B7B7),
                        fontSize: 14,
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0xFF2B2B2B),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0xFF2B2B2B),
                          width: 1,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            StreamBuilder<List<BeritaModel>>(
              stream: _newsService.getBeritaStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Text(
                      'Gagal memuat berita: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final query = _searchController.text.trim();
                final filteredNews =
                    snapshot.data
                        ?.where((berita) => _matchesQuery(berita, query))
                        .toList() ??
                    [];

                if (filteredNews.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Center(
                      child: Text(
                        'Tidak ada berita yang cocok.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2B2B2B),
                        ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredNews.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final berita = filteredNews[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _openDetailBerita(berita),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: berita.imgUrl.startsWith('http')
                                    ? Image.network(
                                        berita.imgUrl,
                                        width: 88,
                                        height: 88,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                width: 88,
                                                height: 88,
                                                color: const Color(0xFFEFEFEF),
                                                child: const Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                      )
                                    : Container(
                                        width: 88,
                                        height: 88,
                                        color: const Color(0xFFEFEFEF),
                                        child: const Icon(
                                          Icons.image_outlined,
                                          color: Colors.grey,
                                        ),
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
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2B2B2B),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      berita.deskripsi,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF666666),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
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
        selectedItemColor: const Color.fromARGB(255, 51, 96, 33),
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
