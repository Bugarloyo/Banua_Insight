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
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc['id_user'] ?? user.uid.hashCode);
      }
    }
    return null;
  }

  // Fungsi Register Akun Khusus User Biasa
  Future<UserModel?> registerUser(String email, String password, String username, String nama) async {
    return await register(email, password, username, nama, 'user');
  }

  // Fungsi Register / Daftar (General)
  Future<UserModel?> register(String email, String password, String username, String nama, String role) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan informasi user ini ke Firestore (termasuk rolenya)
      int idUser = credential.user!.uid.hashCode; // Hash string uid menjadi id int agar sesuai dengan UML
      UserModel newUser = UserModel(
        idUser: idUser,
        username: username,
        role: role, // 'admin' atau 'user'
        password: password, // Peringatan: Sebaiknya jangan menyimpan plain password di Firestore untuk produksi
        email: email,
        savedNews: '', // String kosongan, atau bisa disesuaikan format JSON/ID array
        photoUrl: '', // Foto profil default kosongan
        nama: nama,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set(newUser.toMap());

      return newUser;
    } catch (e) {
      print('Register Error: $e');
      return null;
    }
  }

  // Fungsi Login / Masuk
  Future<UserModel?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return await getCurrentUserData();
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  // Fungsi Logout / Keluar
  Future<void> logout() async {
    await _auth.signOut();
  }
}
