import 'package:flutter/material.dart';

class Simpan extends StatelessWidget {
  const Simpan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Berita berhasil disimpan!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}