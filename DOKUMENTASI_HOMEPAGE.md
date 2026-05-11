# Dokumentasi Homepage Banua Insight

Catatan perubahan untuk homepage dan fitur tambah berita.

## Perubahan yang dilakukan

- Tombol `Tambah` pada bottom navbar di [lib/features/home_page/ui/home_page.dart](lib/features/home_page/ui/home_page.dart) sekarang membuka halaman [lib/features/add_news/tambah_berita.dart](lib/features/add_news/tambah_berita.dart).
- File [lib/features/add_news/tambah_berita.dart](lib/features/add_news/tambah_berita.dart) sekarang berisi form tambah berita yang langsung menyimpan data ke Firestore.
- Setelah data berhasil disimpan, muncul alert sukses `Berita berhasil ditambah`.
- Homepage sekarang membaca data berita dari Firestore secara realtime lewat `NewsService.getBeritaStream()`.
- Halaman detail dan edit sekarang memakai data berita asli, bukan lagi teks statis.
- Fitur hapus sudah terhubung ke `NewsService.deleteBerita()`.

## Fungsi yang dipakai

- `Navigator.push(...)`: dipakai untuk pindah dari homepage ke halaman tambah berita.
- `MaterialPageRoute`: dipakai untuk membuat transisi halaman baru.
- `StatefulWidget`: dipakai karena halaman tambah berita punya state loading dan input form.
- `TextEditingController`: dipakai untuk menangkap isi field input dari user.
- `Form` dan `GlobalKey<FormState>`: dipakai untuk validasi input sebelum disimpan.
- `ScaffoldMessenger.of(context).showSnackBar(...)`: dipakai untuk memberi notifikasi sukses atau gagal.
- `NewsService.addBerita(...)`: dipakai untuk menyimpan berita baru ke Firestore.
- `NewsService.getBeritaStream()`: dipakai untuk menampilkan berita terbaru di homepage secara realtime.
- `NewsService.editBerita(...)`: dipakai untuk memperbarui berita yang sudah tersimpan.
- `NewsService.deleteBerita(...)`: dipakai untuk menghapus berita dari database.
- `showDialog(...)`: dipakai untuk alert sukses setelah berita ditambahkan.

## Alur singkat

1. User menekan tombol `Tambah` di navbar.
2. Aplikasi membuka halaman tambah berita.
3. User mengisi judul, deskripsi, isi konten, URL gambar, dan URL maps.
4. Saat tombol simpan ditekan, form divalidasi.
5. Jika valid, data dikirim ke Firestore lewat `NewsService`.
6. Muncul alert sukses, lalu user kembali ke homepage.
7. Homepage mengambil data terbaru dari Firestore dan menampilkannya.
8. Dari halaman detail, user bisa edit atau hapus berita.

## Command yang bisa dipakai

Kalau kamu mau langsung coba fitur tambah berita, urutannya begini:

1. `flutter pub get` untuk memastikan dependency sudah terpasang.
2. `flutter run` untuk menjalankan aplikasi di device emulator atau HP.
3. `flutter run -d chrome` kalau mau test di browser web.
4. Setelah aplikasi jalan, buka homepage lalu pencet tombol `Tambah` di navbar bawah.
5. Isi form berita lalu tekan `Simpan Berita`.

Kalau kamu hanya ubah file Dart dan aplikasi sudah sedang berjalan, biasanya cukup pakai hot reload dari VS Code atau tekan `r` di terminal Flutter.