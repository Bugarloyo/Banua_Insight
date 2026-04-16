import 'package:cloud_firestore/cloud_firestore.dart';

class BeritaModel {
  int idBerita;
  String judul;
  String deskripsi;
  String isiKonten;
  String imgUrl;
  int likesCount;
  Timestamp createdAt;
  String mapsUrl;

  BeritaModel({
    required this.idBerita,
    required this.judul,
    required this.deskripsi,
    required this.isiKonten,
    required this.imgUrl,
    required this.likesCount,
    required this.createdAt,
    required this.mapsUrl,
  });

  // void tambahData() {
  //   // Implementasi logika tambah berita
  // }

  // void ubahData() {
  //   // Implementasi logika ubah berita
  // }

  // void hapusData() {
  //   // Implementasi logika hapus berita
  // }

  // void lihatData() {
  //   // Implementasi logika lihat/baca berita
  // }

  factory BeritaModel.fromMap(Map<String, dynamic> map, int id) {
    return BeritaModel(
      idBerita: id,
      judul: map['judul'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      isiKonten: map['isi_konten'] ?? '',
      imgUrl: map['img_url'] ?? '',
      likesCount: map['likes_count'] ?? 0,
      createdAt: map['created_at'] ?? Timestamp.now(),
      mapsUrl: map['maps_url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_berita': idBerita,
      'judul': judul,
      'deskripsi': deskripsi,
      'isi_konten': isiKonten,
      'img_url': imgUrl,
      'likes_count': likesCount,
      'created_at': createdAt,
      'maps_url': mapsUrl,
    };
  }
}

