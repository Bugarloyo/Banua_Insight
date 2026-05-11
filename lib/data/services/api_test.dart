import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';
import 'news_service.dart';

// https://redkal.com/wp-json/wp/v2/posts
// tolong buatkan api untuk ngebaca data berita

void main() async {
  // Contoh penggunaan API untuk membaca berita
  NewsService newsService = NewsService();

  print('Memulai pengambilan berita...');

  try {
    // Mendapatkan berita dari WordPress API
    List<BeritaModel> newsList = await newsService.getWordPressNews();
    
    for (var news in newsList) {
      print('Judul: ${news.judul}');
      print('Deskripsi: ${news.deskripsi}');
      print('URL Gambar: ${news.imgUrl}');
      print('Tanggal Dibuat: ${news.createdAt.toDate()}');
      print('---');
    }
  } catch (error) {
    print('Error fetching news: $error');
  }
}
