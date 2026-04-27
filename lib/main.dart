// import 'package:banuainsight_project/features/login/splash_screen.dart';
import 'package:banuainsight_project/features/profile/profile.dart';
import 'package:flutter/material.dart';
// import 'package:banuainsight_project/features/news_detail/ui/detail_berita.dart'; // import halaman baru

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Kita ubah *home* nya dari SplashScreen menjadi DetailBerita agar langsung muncul saat di-run
      home: const Profile(), 
    );
  }
}
