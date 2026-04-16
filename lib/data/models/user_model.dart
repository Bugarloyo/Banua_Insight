class UserModel {
  int idUser;
  String username;
  String role;
  String password;
  String email;
  String savedNews;
  String photoUrl;
  String nama;

  UserModel({
    required this.idUser,
    required this.username,
    required this.role,
    required this.password,
    required this.email,
    required this.savedNews,
    required this.photoUrl,
    required this.nama,
  });

  void tambahData() {
    // Implementasi logika tambah data user
  }

  void ubahData() {
    // Implementasi logika ubah data user
  }

  factory UserModel.fromMap(Map<String, dynamic> map, int id) {
    return UserModel(
      idUser: id,
      username: map['username'] ?? '',
      role: map['role'] ?? 'user',
      password: map['password'] ?? '',
      email: map['email'] ?? '',
      savedNews: map['saved_news'] ?? '',
      photoUrl: map['photo_url'] ?? '',
      nama: map['nama'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_user': idUser,
      'username': username,
      'role': role,
      'password': password,
      'email': email,
      'saved_news': savedNews,
      'photo_url': photoUrl,
      'nama': nama,
    };
  }
}
