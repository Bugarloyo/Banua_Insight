# Banua Insight

Banua Insight adalah aplikasi berita berbasis Flutter yang terintegrasi dengan Firebase. Aplikasi ini mendukung alur autentikasi, membaca berita secara realtime, melihat detail berita, menambah dan mengelola berita, serta fitur like dan bookmark untuk pengguna.

## Ringkasan Aplikasi

Aplikasi ini dirancang untuk dua jenis pengguna:

- Admin yang dapat menambah, mengedit, dan menghapus berita.
- User yang dapat membaca berita, mencari berita, memberi like, dan menyimpan berita ke bookmark.

Data berita disimpan di Firestore dan ditampilkan secara realtime melalui stream. Autentikasi menggunakan Firebase Authentication, sedangkan data profil dan interaksi pengguna disimpan di Firestore.

## Fitur Utama

- Autentikasi login dan register menggunakan Firebase Authentication.
- Splash screen sebagai halaman pembuka aplikasi.
- Homepage berita dengan daftar rekomendasi dan berita viral.
- Detail berita lengkap dengan navigasi ke aksi edit dan hapus.
- Tambah berita untuk admin.
- Edit berita untuk admin.
- Hapus berita dengan dialog konfirmasi dan notifikasi sukses.
- Search berita.
- Like berita.
- Bookmark atau simpan berita.
- Halaman profil pengguna.
- Riwayat baca dan daftar simpan untuk user.
- Pengambilan data berita realtime dari Firestore.

## Teknologi yang Digunakan

- Flutter
- Dart
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- intl untuk format tanggal lokal Indonesia
- shared_preferences untuk penyimpanan lokal

## Struktur Project

Berikut ringkasan struktur folder utama yang digunakan di project ini:

```text
lib/
	main.dart
	firebase_options.dart
	data/
		models/
		services/
	features/
		login/
		home_page/
		news_detail/
		add_news/
		search_news/
		profile/
		save/
		user/
assets/
	img/
android/
ios/
web/
windows/
linux/
macos/
test/
```

## Alur Aplikasi

1. Aplikasi dijalankan dan menampilkan splash screen.
2. User masuk ke halaman login atau register.
3. Setelah login berhasil, user melihat homepage berita.
4. Homepage menampilkan data berita dari Firestore secara realtime.
5. User dapat membuka detail berita untuk membaca isi lengkap.
6. Admin dapat menambah, mengedit, atau menghapus berita.
7. User dapat memberikan like atau menyimpan berita ke bookmark.
8. User dapat membuka halaman pencarian untuk mencari berita tertentu.

## Model Data Firestore

Project ini memakai beberapa koleksi utama di Firestore.

### Koleksi `berita`

Menyimpan data artikel berita.

Field yang umum dipakai:

- `id_berita`
- `id_user_admin`
- `nama_admin`
- `judul`
- `deskripsi`
- `isi_konten`
- `img_url`
- `created_at`
- `likes_count`

### Koleksi `users`

Menyimpan data user yang login.

Field yang umum dipakai:

- `id_user`
- `username`
- `role`
- `password`
- `email`
- `savedNews`
- `photoUrl`
- `nama`

### Koleksi `likes`

Menyimpan data like berita.

Field yang umum dipakai:

- `id_user`
- `id_berita`
- `created_at`

### Koleksi `bookmarks`

Menyimpan data berita yang disimpan user.

Field yang umum dipakai:

- `id_user`
- `id_berita`
- `created_at`

## Setup Project

### 1. Install dependency

Jalankan perintah berikut di root project:

```bash
flutter pub get
```

### 2. Pastikan Firebase sudah terhubung

Project ini sudah memakai `firebase_options.dart` dan file konfigurasi Android Firebase. Pastikan:

- `android/app/google-services.json` sudah sesuai dengan project Firebase.
- `lib/firebase_options.dart` sesuai dengan konfigurasi Firebase terbaru.
- Authentication dan Firestore sudah aktif di Firebase Console.

### 3. Cek device yang tersedia

```bash
flutter devices
```

### 4. Jalankan aplikasi

Untuk Android emulator atau perangkat fisik:

```bash
flutter run
```

Untuk web:

```bash
flutter run -d chrome
```

## Cara Menjalankan di Lokal

1. Buka project di VS Code.
2. Jalankan `flutter pub get`.
3. Pastikan Firebase sudah tersambung.
4. Jalankan `flutter run` atau pilih device target dari VS Code.
5. Tunggu aplikasi selesai build, lalu login menggunakan akun yang tersedia.

## Panduan Fitur

### Login dan Register

Pengguna dapat membuat akun baru atau masuk menggunakan email dan password. Data akun disimpan ke Firebase Authentication dan detail profil disimpan ke Firestore.

### Homepage

Homepage menampilkan:

- Logo Banua Insight.
- Rekomendasi berita.
- Daftar berita viral.
- Bottom navigation untuk berpindah ke cari dan tambah berita.

### Tambah Berita

Halaman tambah berita digunakan untuk membuat artikel baru. Setelah data dikirim, berita akan langsung tersimpan ke Firestore dan tampil di homepage realtime.

### Detail Berita

Halaman detail menampilkan isi lengkap berita dan menjadi tempat akses fitur edit, hapus, like, dan bookmark.

### Like dan Bookmark

User dapat memberi like atau menyimpan berita. Data interaksi ini disimpan di koleksi `likes` dan `bookmarks`.

### Search

Fitur pencarian digunakan untuk mencari berita berdasarkan kata kunci.

### Profile

Halaman profil menampilkan informasi akun pengguna dan menjadi area untuk pengelolaan data akun.

## Service Layer

Project ini memiliki service utama di layer data:

- `AuthService` untuk register, login, logout, dan mengambil data user aktif.
- `NewsService` untuk mengambil berita realtime, tambah berita, edit berita, hapus berita, like, bookmark, dan membaca data simpanan user.

## Dokumentasi Tambahan

Beberapa file dokumentasi yang bisa dibaca jika ingin detail fitur per halaman:

- `DOKUMENTASI_AUTENTIKASI.md`
- `DOKUMENTASI_HOMEPAGE.md`
- `DOKUMENTASI_HAPUS_BERITA.md`
- `DOKUMENTASI_LIKE_BOOKMARK.md`
- `DOKUMENTASI_NAVIGASI_HALAMAN.md`

## Troubleshooting

### 1. Aplikasi gagal jalan karena Firebase

Periksa apakah file konfigurasi Firebase sudah sesuai dan service Firebase sudah diaktifkan di console.

### 2. Data berita tidak muncul

Pastikan koleksi `berita` sudah ada di Firestore dan field `created_at` terisi dengan format timestamp yang benar.

### 3. Gambar berita tidak tampil

Pastikan `img_url` berisi URL valid yang bisa diakses dari browser.

### 4. Login gagal

Periksa apakah email dan password benar, serta pastikan Authentication sudah diaktifkan di Firebase.

## Catatan Pengembangan

Project ini masih bisa dikembangkan lebih lanjut, misalnya dengan:

- validasi form yang lebih ketat,
- role-based routing yang lebih rapi,
- pagination untuk daftar berita,
- optimasi tampilan untuk tablet atau web,
- penyimpanan media berita ke Firebase Storage.

## Lisensi

Project ini digunakan untuk pengembangan aplikasi Banua Insight dan belum memiliki lisensi publik khusus.
