import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart'; // import the UserModel

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream untuk memeriksa status user yang sedang login
  Stream<User?> get userStream => _auth.authStateChanges();

  // Mendapatkan detail Data User saat ini beserta role-nya (admin / user)
  Future<UserModel?> getCurrentUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        return UserModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc['id_user'] ?? user.uid.hashCode,
        );
      }
    }
    return null;
  }

  // Fungsi Register Akun Khusus User Biasa
  Future<UserModel?> registerUser(
    String email,
    String password,
    String username,
    String nama,
  ) async {
    return await register(email, password, username, nama, 'user');
  }

  // Fungsi Register / Daftar (General)
  Future<UserModel?> register(
    String email,
    String password,
    String username,
    String nama,
    String role,
  ) async {
    try {
      final normalizedRole = role.toLowerCase() == 'admin' ? 'admin' : 'user';

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan informasi user ini ke Firestore (termasuk rolenya)
      int idUser = credential
          .user!
          .uid
          .hashCode; // Hash string uid menjadi id int agar sesuai dengan UML
      UserModel newUser = UserModel(
        idUser: idUser,
        username: username,
        role: normalizedRole, // 'admin' atau 'user'
        password:
            password, // Peringatan: Sebaiknya jangan menyimpan plain password di Firestore untuk produksi
        email: email,
        savedNews:
            '', // String kosongan, atau bisa disesuaikan format JSON/ID array
        photoUrl: '', // Foto profil default kosongan
        nama: nama,
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(newUser.toMap());

      return newUser;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthMessage(e);
    } on FirebaseException catch (e) {
      try {
        final currentUser = _auth.currentUser;
        if (currentUser != null) {
          await currentUser.delete();
        }
      } catch (_) {
        // Abaikan rollback error agar pesan asli tetap muncul.
      }
      throw 'Gagal menyimpan data user ke Firestore: ${e.message ?? e.code}';
    } catch (e) {
      throw 'Register gagal: $e';
    }
  }

  // Fungsi Login / Masuk
  Future<UserModel?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return await getCurrentUserData();
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthMessage(e);
    } catch (e) {
      throw 'Login gagal: $e';
    }
  }

  // Fungsi Logout / Keluar
  Future<void> logout() async {
    await _auth.signOut();
  }

  String _mapFirebaseAuthMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan login atau gunakan email lain.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'weak-password':
        return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
      case 'user-not-found':
        return 'Akun tidak ditemukan.';
      case 'wrong-password':
        return 'Password salah.';
      case 'invalid-credential':
        return 'Email atau password salah.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      default:
        return e.message ?? 'Terjadi kesalahan autentikasi (${e.code}).';
    }
  }
}
