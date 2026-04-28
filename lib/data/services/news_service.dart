import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/news_model.dart';

class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _newsCollection = 'berita';

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
    required String mapsUrl,
  }) async {
    // Karena kita masih berbasis Document dari Firebase tapi IDnya butuh int,
    // kita menggunakan reference biasa dahulu lalu ambil hashCode dari id tsb menjadi idBerita (int)
    final docRef = _firestore.collection(_newsCollection).doc();
    int idBerita = docRef.id.hashCode;

    final newBerita = BeritaModel(
      idBerita: idBerita,
      judul: judul,
      deskripsi: deskripsi,
      isiKonten: isiKonten,
      imgUrl: imgUrl,
      likesCount: 0,
      createdAt: Timestamp.now(),
      mapsUrl: mapsUrl,
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
    String? mapsUrl,
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
      if (mapsUrl != null) updateData['maps_url'] = mapsUrl;

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

  // NOTE: Di Model spesifikasi belum ada array 'likedBy' / List.
  // Untuk Likes dan SavedNews sebaiknya dieksekusi secara terpisah dalam SubCollection / JSON array manual
  // karena "savedNews" berupa String didalam model. Format di UML Anda tidak memasukkan Array Like List kedalam Class Berita.
}
