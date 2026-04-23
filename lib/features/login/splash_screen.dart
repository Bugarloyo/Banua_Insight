import 'package:flutter/material.dart';
import 'login_page.dart'; // import halaman login_page

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _stage =
      0; // 0: Start, 1: Muncul awal (Stage 1), 2: Membesar & Teks muncul (Stage 2)

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    // Memulai Stage 1 (Logo & Blob muncul barengan)
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Sedikit delay awal biar transisi layarnya smooth
    if (mounted) setState(() => _stage = 1);

    // Tahan bentar di Stage 1 sebelum pindah ke Stage 2
    await Future.delayed(const Duration(milliseconds: 1500));

    // Memulai Stage 2 (Pointer membesar memenuhi page, logo sedikit membesar, text perlahan muncul)
    if (mounted) setState(() => _stage = 2);

    // Tunggu animasi Stage 2 selesai sebelum navigasi ke halaman Login
    await Future.delayed(const Duration(milliseconds: 1800));

    if (mounted) {
      // Menggunakan custom page route agar smooth fade-in ke LoginPage
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const LoginPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pengaturan Skala animasi. Stage 2 blob dibikin "5.0" agar membesar penuh
    final double blobScale = _stage == 0 ? 0.0 : (_stage == 1 ? 1.0 : 5.0);
    // Skala Logo Stage 2 kita bikin jadi 1.3 kali lipat lebih besar dari Stage 1
    final double logoScale = _stage == 0 ? 0.0 : (_stage == 1 ? 1.0 : 1.3);
    // Transparansi dari Text, muncul di stage 2 (1.0 = terlihat)
    final double textOpacity = _stage == 2 ? 1.0 : 0.0;

    // Pergeseran posisi layar (opsional, karena membesar kita turunin/geser keatas dikit spy text gak ketutup)
    final double topSpacing = _stage == 2 ? 20.0 : 60.0;

    return Scaffold(
      backgroundColor: Colors.white,
      // Menggunakan Stack dasar utama agar blob bisa menutupi keseluruhan layar jika besar
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 1200),
              height: topSpacing,
              curve: Curves.easeInOutCubic,
            ),
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip
                  .none, // Set Clip.none agar pointer/blob yang membesar tidak kepotong
              children: [
                // Pointer / Blob animasi skala
                AnimatedScale(
                  scale: blobScale,
                  duration: const Duration(milliseconds: 1200),
                  // Stage 1 mantul keluar, Stage 2 dia smooth aja membesar
                  curve: _stage == 1
                      ? Curves.easeOutBack
                      : Curves.easeInOutCubic,
                  child: CustomPaint(
                    size: const Size(290, 290),
                    painter: BlobPainter(),
                  ),
                ),
                // Logo Image animasi skala
                AnimatedScale(
                  scale: logoScale,
                  duration: const Duration(milliseconds: 1200),
                  curve: _stage == 1
                      ? Curves.easeOutBack
                      : Curves.easeInOutCubic,
                  child: Image.asset(
                    'assets/img/Logo_banua.png',
                    width: 280, // Ukuran asli saat Stage 1
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

            // Jarak antara teks dan gambar
            AnimatedContainer(
              duration: const Duration(milliseconds: 1200),
              height: _stage == 2
                  ? 50
                  : 24, // Jaraknya kita perlebar saat tahap 2
              curve: Curves.easeInOutCubic,
            ),

            // Teks Name (muncul tahap 2) dianimasikan dengan Opacity & Sedikit digeser naik
            AnimatedOpacity(
              opacity: textOpacity,
              duration: const Duration(milliseconds: 1000), // Perlahan muncul
              child: AnimatedSlide(
                offset: _stage == 2 ? Offset.zero : const Offset(0, 0.5),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                child: const Column(
                  children: [
                    Text(
                      "Banua",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:
                            36, // Disesuaikan ukuran font saat muncul agar pas dgn logo yg membesar
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 51, 96, 33),
                        height: 1.1,
                      ),
                    ),
                    Text(
                      "-Insight-",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 230, 141, 58),
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Class untuk menggambar bentuk organik (Blob)
class BlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Sesuaikan warna blob sesuai preferensi kamu (misal: warna abu-abu muda)
    final paint = Paint()
      ..color = const Color(0xFFE5E5E5)
      ..style = PaintingStyle.fill;

    final path = Path();
    // Menggambar kurva untuk membentuk blob seperti gambar
    path.moveTo(size.width * 0.2, size.height * 0.15);
    path.cubicTo(
      size.width * 0.6,
      size.height * -0.05,
      size.width * 1.0,
      size.height * 0.2,
      size.width * 0.9,
      size.height * 0.6,
    );
    path.cubicTo(
      size.width * 0.8,
      size.height * 1.0,
      size.width * 0.2,
      size.height * 1.1,
      size.width * 0.05,
      size.height * 0.7,
    );
    path.cubicTo(
      size.width * -0.1,
      size.height * 0.4,
      size.width * 0.0,
      size.height * 0.25,
      size.width * 0.2,
      size.height * 0.15,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
