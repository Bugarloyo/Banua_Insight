import 'package:banuainsight_project/features/news_detail/ui/detail_berita.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const String _sampleImage = 'assets/img/download.jpg';
  static const String _sampleTitle =
      'Ini adalah artikel kucing yang jarang di temui oleh orang lain';
  static const String _sampleDate = 'Senin 30 Maret 2026';
  static const String _viralTitle =
      'BANJARBARU - Polda Kalsel gelar razia lagi! Terhitung sejak hari ini, Senin (10/2/2025), Polda Kalimantan Selatan';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openDetailBerita() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DetailBerita()),
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

  Widget _buildRecommendationCard({required EdgeInsetsGeometry margin}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: margin,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: _openDetailBerita,
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
                  child: Image.asset(
                    _sampleImage,
                    width: 310,
                    height: 170,
                    fit: BoxFit.cover,
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
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _sampleTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10),
                      Text(_sampleDate, style: TextStyle(fontSize: 10)),
                      SizedBox(height: 10),
                      Row(
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

  Widget _buildViralItem({required EdgeInsetsGeometry padding}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: _openDetailBerita,
        child: Padding(
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                _sampleImage,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: const Text(
                    _viralTitle,
                    style: TextStyle(
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
                        // Handle avatar press
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.grey, thickness: 1, height: 2),
            _buildSectionTitle('Rekomendasi'),
            SizedBox(
              height: 310,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildRecommendationCard(
                    margin: const EdgeInsets.only(left: 20.0),
                  ),
                  _buildRecommendationCard(
                    margin: const EdgeInsets.only(left: 20.0),
                  ),
                  _buildRecommendationCard(
                    margin: const EdgeInsets.only(left: 20.0),
                  ),
                  _buildRecommendationCard(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  ),
                ],
              ),
            ),
            _buildSectionTitle('Berita Viral'),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                _buildViralItem(
                  padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                ),
                _buildViralItem(
                  padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                ),
                _buildViralItem(
                  padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                ),
                _buildViralItem(
                  padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                ),
                _buildViralItem(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    top: 10.0,
                    bottom: 20.0,
                  ),
                ),
              ],
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
