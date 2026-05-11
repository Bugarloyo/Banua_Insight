import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsApiService {
  static const String baseUrl = 'https://redkal.com/wp-json/wp/v2';

  Future<List<BeritaModel>> fetchNews() async {
    try {
      // Menambahkan _embed agar data media (gambar) ikut terambil
      final response = await http.get(Uri.parse('$baseUrl/posts?_embed'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => BeritaModel.fromWordPressJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data berita: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
