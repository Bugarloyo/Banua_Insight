import 'package:banuainsight_project/features/news_detail/ui/detail_berita.dart';
import 'package:banuainsight_project/features/add_news/tambah_berita.dart';
import 'package:banuainsight_project/features/search_news/cari_berita.dart';
import 'package:banuainsight_project/features/profile/profile.dart';
import 'package:banuainsight_project/data/models/news_model.dart';
import 'package:banuainsight_project/data/services/news_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final NewsService _newsService = NewsService();

  Future<void> _onItemTapped(int index) async {
    if (index == 1) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CariBerita(selectedIndex: 1),
        ),
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedIndex = 0;
      });
      return;
    }

    if (index == 2) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TambahBerita()),
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedIndex = 0;
      });
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  void _openDetailBerita(BeritaModel berita) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailBerita(berita: berita)),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationCard({
    required BeritaModel berita,
    required EdgeInsetsGeometry margin,
  }) {
    String formattedDate =
        DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(berita.createdAt.toDate());

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: margin,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => _openDetailBerita(berita),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: berita.imgUrl.startsWith('http')
                      ? Image.network(
                          berita.imgUrl,
                          width: 310,
                          height: 170,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(
                            width: 310,
                            height: 170,
                            
                          ),
                        )
                      : const SizedBox(
                          width: 310,
                          height: 170,
                          
                        ),
                ),
              ),
              Container(
                width: 310,
                height: 115,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        berita.judul,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(formattedDate, style: const TextStyle(fontSize: 10)),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Text(
                            'BANUA',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color.fromARGB(255, 51, 96, 33),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 2),
                          Text(
                            'INSIGHT',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color.fromARGB(255, 230, 141, 58),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViralItem({
    required BeritaModel berita,
    required EdgeInsetsGeometry padding,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () => _openDetailBerita(berita),
        child: Padding(
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: berita.imgUrl.startsWith('http')
                    ? Image.network(
                        berita.imgUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(child: Icon(Icons.broken_image)),
                        ),
                      )
                    : const SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(child: Icon(Icons.image_not_supported)),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text(
                    berita.judul,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
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
            _buildSectionTitle('Rekomendasi'),
            StreamBuilder<List<BeritaModel>>(
              stream: _newsService.getBeritaStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 310,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox(
                    height: 310,
                    child: Center(child: Text("Tidak ada rekomendasi")),
                  );
                }
                final listBerita = snapshot.data!;
                return SizedBox(
                  height: 310,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listBerita.length,
                    itemBuilder: (context, index) {
                      return _buildRecommendationCard(
                        berita: listBerita[index],
                        margin: EdgeInsets.only(
                          left: 20.0,
                          right: index == listBerita.length - 1 ? 20.0 : 0,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            _buildSectionTitle('Berita Viral'),
            StreamBuilder<List<BeritaModel>>(
              stream: _newsService.getBeritaStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Tidak ada berita viral"));
                }
                final listBerita = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listBerita.length,
                  itemBuilder: (context, index) {
                    return _buildViralItem(
                      berita: listBerita[index],
                      padding: EdgeInsets.only(
                        left: 20.0,
                        top: 10.0,
                        bottom: index == listBerita.length - 1 ? 20.0 : 0,
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
        onTap: _onItemTapped,
      ),
    );
  }
}
