import 'package:banuainsight_project/features/login/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('id_ID', null);
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
      home: const SplashScreen(),
      initialRoute: '/Login', // Set initial route ke halaman Login
      routes: {
        '/splashscreen': (context) => const SplashScreen(), // Rute untuk halaman SplashScreen
      },
    );
  }
}
