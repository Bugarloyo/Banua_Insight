import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bookmark_model.dart';
import '../models/news_model.dart';

class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _newsCollection = 'berita';
  final String _likesCollection = 'likes';
  final String _bookmarksCollection = 'bookmarks';

  // [Umum] Mengambil semua Berita dalam bentuk Stream (real-time realtime)
  Stream<List<BeritaModel>> getBeritaStream() {
    return _firestore
        .collection(_newsCollection)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => BeritaModel.fromMap(
                  doc.data(),
                  doc['id_berita'] ?? doc.id.hashCode,
                ),
              )
              .toList(),
        );
  }

  // [Admin] Menambahkan Berita
  Future<void> addBerita({
    required String judul,
    required String deskripsi,
    required String isiKonten,
    required String imgUrl,
    required int idUserAdmin,
    required String namaAdmin,
  }) async {
    // Karena kita masih berbasis Document dari Firebase tapi IDnya butuh int,
    // kita menggunakan reference biasa dahulu lalu ambil hashCode dari id tsb menjadi idBerita (int)
    final docRef = _firestore.collection(_newsCollection).doc();
    int idBerita = docRef.id.hashCode;

    final newBerita = BeritaModel(
      idBerita: idBerita,
      idUserAdmin: idUserAdmin,
      namaAdmin: namaAdmin,
      judul: judul,
      deskripsi: deskripsi,
      isiKonten: isiKonten,
      imgUrl: imgUrl,
      createdAt: Timestamp.now(),
    );
    await docRef.set(newBerita.toMap());
  }

  // [Admin] Mengedit Berita (Membutuhkan reference dari Firestore (bisa dicari melalui id_berita int nya))
  Future<void> editBerita({
    required int idBerita,
    required String judul,
    required String deskripsi,
    required String isiKonten,
    String? imgUrl,
  }) async {
    // Cari dokumen aslinya di Firestore berdasarkan field id_berita
    QuerySnapshot query = await _firestore
        .collection(_newsCollection)
        .where('id_berita', isEqualTo: idBerita)
        .get();

    if (query.docs.isNotEmpty) {
      String docId = query.docs.first.id;

      Map<String, dynamic> updateData = {
        'judul': judul,
        'deskripsi': deskripsi,
        'isi_konten': isiKonten,
      };
      if (imgUrl != null) updateData['img_url'] = imgUrl;

      await _firestore
          .collection(_newsCollection)
          .doc(docId)
          .update(updateData);
    }
  }

  // [Admin] Menghapus Berita
  Future<void> deleteBerita(int idBerita) async {
    QuerySnapshot query = await _firestore
        .collection(_newsCollection)
        .where('id_berita', isEqualTo: idBerita)
        .get();
    for (var doc in query.docs) {
      await _firestore.collection(_newsCollection).doc(doc.id).delete();
    }
  }

  // [User] Fitur Like Berita
  Future<void> toggleLikeBerita(int idUser, int idBerita) async {
    // Cari apakah user sudah like berita ini
    QuerySnapshot likeQuery = await _firestore
        .collection(_likesCollection)
        .where('id_user', isEqualTo: idUser)
        .where('id_berita', isEqualTo: idBerita)
        .get();

    // Cari dokumen berita untuk update likes_count
    QuerySnapshot newsQuery = await _firestore
        .collection(_newsCollection)
        .where('id_berita', isEqualTo: idBerita)
        .get();

    if (newsQuery.docs.isEmpty) return;
    DocumentReference newsDoc = newsQuery.docs.first.reference;

    if (likeQuery.docs.isEmpty) {
      // Belum like, maka kita tambahkan like
      await _firestore.collection(_likesCollection).add({
        'id_user': idUser,
        'id_berita': idBerita,
        'created_at': FieldValue.serverTimestamp(),
      });
      // Increment likesCount di berita
      await newsDoc.update({'likes_count': FieldValue.increment(1)});
    } else {
      // Sudah like, maka kita hapus like (unlike)
      await likeQuery.docs.first.reference.delete();
      // Decrement likesCount di berita
      await newsDoc.update({'likes_count': FieldValue.increment(-1)});
    }
  }

  // [User] Fitur Save / Bookmark Berita
  Future<void> toggleBookmarkBerita(int idUser, int idBerita) async {
    QuerySnapshot bookmarkQuery = await _firestore
        .collection(_bookmarksCollection)
        .where('id_user', isEqualTo: idUser)
        .where('id_berita', isEqualTo: idBerita)
        .get();

    if (bookmarkQuery.docs.isEmpty) {
      await _firestore.collection(_bookmarksCollection).add({
        'id_user': idUser,
        'id_berita': idBerita,
        'created_at': FieldValue.serverTimestamp(),
      });
    } else {
      await bookmarkQuery.docs.first.reference.delete();
    }
  }

  // [User] Mengecek apakah user sudah like berita tertentu
  Future<bool> isBeritaLiked(int idUser, int idBerita) async {
    QuerySnapshot query = await _firestore
        .collection(_likesCollection)
        .where('id_user', isEqualTo: idUser)
        .where('id_berita', isEqualTo: idBerita)
        .get();
    return query.docs.isNotEmpty;
  }

  // [User] Mengecek apakah berita sudah di-save
  Future<bool> isBeritaBookmarked(int idUser, int idBerita) async {
    QuerySnapshot query = await _firestore
        .collection(_bookmarksCollection)
        .where('id_user', isEqualTo: idUser)
        .where('id_berita', isEqualTo: idBerita)
        .get();
    return query.docs.isNotEmpty;
  }

  Stream<List<BeritaModel>> getBookmarkedBeritaStream(int idUser) {
    return _firestore
        .collection(_bookmarksCollection)
        .where('id_user', isEqualTo: idUser)
        .snapshots()
        .asyncMap((snapshot) async {
          final bookmarks =
              snapshot.docs
                  .map((doc) => BookmarkModel.fromMap(doc.data(), doc.id))
                  .toList()
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          final newsItems = await Future.wait(
            bookmarks.map((bookmark) async {
              final newsQuery = await _firestore
                  .collection(_newsCollection)
                  .where('id_berita', isEqualTo: bookmark.idBerita)
                  .limit(1)
                  .get();

              if (newsQuery.docs.isEmpty) {
                return null;
              }

              final doc = newsQuery.docs.first;
              return BeritaModel.fromMap(
                doc.data(),
                doc['id_berita'] ?? doc.id.hashCode,
              );
            }),
          );

          return newsItems.whereType<BeritaModel>().toList();
        });
  }

  // NOTE: Di Model spesifikasi belum ada array 'likedBy' / List.
  // Untuk Likes dan SavedNews sebaiknya dieksekusi secara terpisah dalam SubCollection / JSON array manual
  // karena "savedNews" berupa String didalam model. Format di UML Anda tidak memasukkan Array Like List kedalam Class Berita.
}
