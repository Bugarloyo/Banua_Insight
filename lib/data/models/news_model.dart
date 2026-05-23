import 'package:cloud_firestore/cloud_firestore.dart';

class BeritaModel {
  int idBerita;
  int idUserAdmin;
  String namaAdmin;
  String judul;
  String deskripsi;
  String isiKonten;
  String imgUrl;
  Timestamp createdAt;

  BeritaModel({
    required this.idBerita,
    required this.idUserAdmin,
    required this.namaAdmin,
    required this.judul,
    required this.deskripsi,
    required this.isiKonten,
    required this.imgUrl,
    required this.createdAt,
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
      idUserAdmin: map['id_user_admin'] ?? 0,
      namaAdmin: map['nama_admin'] ?? '',
      judul: map['judul'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      isiKonten: map['isi_konten'] ?? '',
      imgUrl: map['img_url'] ?? '',
      createdAt: map['created_at'] ?? Timestamp.now(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id_berita': idBerita,
      'id_user_admin': idUserAdmin,
      'nama_admin': namaAdmin,
      'judul': judul,
      'deskripsi': deskripsi,
      'isi_konten': isiKonten,
      'img_url': imgUrl,
      'created_at': createdAt
    };
  }
}
