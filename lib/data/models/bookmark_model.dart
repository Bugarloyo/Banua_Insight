import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkModel {
  final String idBookmark;
  final int idUser;
  final int idBerita;
  final Timestamp createdAt;

  BookmarkModel({
    required this.idBookmark,
    required this.idUser,
    required this.idBerita,
    required this.createdAt,
  });

  factory BookmarkModel.fromMap(Map<String, dynamic> map, String id) {
    return BookmarkModel(
      idBookmark: id,
      idUser: map['id_user'] ?? 0,
      idBerita: map['id_berita'] ?? 0,
      createdAt: map['created_at'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'id_user': idUser, 'id_berita': idBerita, 'created_at': createdAt};
  }
}
