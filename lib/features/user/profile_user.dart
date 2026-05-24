import 'package:banuainsight_project/data/models/user_model.dart';
import 'package:banuainsight_project/data/services/auth_service.dart';
import 'package:banuainsight_project/features/user/cari_berita_user.dart';
import 'package:banuainsight_project/features/user/home_page_user.dart';
import 'package:banuainsight_project/features/user/riwayat_baca_user.dart';
import 'package:banuainsight_project/features/user/simpan_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileUser extends StatelessWidget {
  const ProfileUser({super.key});

  static const List<Color> _avatarColors = <Color>[
    Color(0xFFE53935),
    Color(0xFFD81B60),
    Color(0xFF8E24AA),
    Color(0xFF5E35B1),
    Color(0xFF3949AB),
    Color(0xFF1E88E5),
    Color(0xFF039BE5),
    Color(0xFF00897B),
    Color(0xFF43A047),
    Color(0xFFF4511E),
  ];

  Future<UserModel?> get _currentUserFuture => AuthService().getCurrentUserData();

  String _getInitial(String username) {
    final trimmedUsername = username.trim();
    if (trimmedUsername.isEmpty) return 'U';
    return trimmedUsername[0].toUpperCase();
  }

  Color _getAvatarColor(String username) {
    final trimmedUsername = username.trim();
    if (trimmedUsername.isEmpty) return _avatarColors.first;
    final index = trimmedUsername.codeUnits.fold<int>(0, (sum, unit) => sum + unit) % _avatarColors.length;
    return _avatarColors[index];
  }

  Future<void> _onItemTapped(BuildContext context, int index) async {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePageUser()),
      );
      return;
    }

    if (index == 1) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CariBeritaUser(selectedIndex: 1)),
      );
      return;
    }

    if (index == 2) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RiwayatBacaUser(selectedIndex: 2)),
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
      body: FutureBuilder<UserModel?>(
        future: _currentUserFuture,
        builder: (context, snapshot) {
          final user = snapshot.data;
          final username = user?.username.isNotEmpty == true ? user!.username : 'User';
          final initial = _getInitial(username);
          final avatarColor = _getAvatarColor(username);

          return Center(
            child: Transform.translate(
              offset: const Offset(0, -200),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: avatarColor,
                    radius: 55,
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const CircularProgressIndicator()
                  else
                    Text(
                      username,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 350,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SimpanUser()),
                        );
                      },
                      icon: const Icon(CupertinoIcons.bookmark_fill, color: Colors.white, size: 18),
                      label: const Text('Bookmarks'),
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
                      onPressed: () async {
                        await AuthService().logout();
                        if (!context.mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/splashscreen',
                          (route) => false,
                        );
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