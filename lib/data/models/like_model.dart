import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  final String idLike;
  final int idUser;
  final int idBerita;
  final Timestamp createdAt;

  LikeModel({
    required this.idLike,
    required this.idUser,
    required this.idBerita,
    required this.createdAt,
  });

  factory LikeModel.fromMap(Map<String, dynamic> map, String id) {
    return LikeModel(
      idLike: id,
      idUser: map['id_user'] ?? 0,
      idBerita: map['id_berita'] ?? 0,
      createdAt: map['created_at'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_user': idUser,
      'id_berita': idBerita,
      'created_at': createdAt,
    };
  }
}
