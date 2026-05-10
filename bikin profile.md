# Dokumentasi Pengerjaan Hari Ini

Tanggal: 10 Mei 2026

## Ringkasan Perubahan

Hari ini saya membantu merapikan beberapa bagian aplikasi Banua Insight:

1. Menghubungkan avatar di halaman Home ke halaman Profile.
2. Memperbaiki error struktur widget di `profile.dart`.
3. Menyusun ulang layout Profile supaya isi halaman bisa digeser bersama dengan satu `Transform.translate`.
4. Memperbaiki bottom navigation bar di halaman Profile.
5. Memperbaiki halaman `CariBerita` supaya navbar-nya konsisten dan tab aktifnya benar.
6. Memperbaiki halaman `TambahBerita` supaya tombol Search di navbar bisa dipencet dan pindah ke halaman cari berita.

## File yang Terdampak

- `lib/features/home_page/ui/home_page.dart`
- `lib/features/profile/profile.dart`
- `lib/features/search_news/cari_berita.dart`
- `lib/features/add_news/tambah_berita.dart`

## Fungsi / Widget Flutter yang Dipakai

### Navigasi

- `Navigator.push`
- `Navigator.pushReplacement`
- `Navigator.pop`
- `Navigator.popUntil`

### Layout dan Tampilan

- `Scaffold`
- `AppBar`
- `Center`
- `Column`
- `Row`
- `SizedBox`
- `Padding`
- `Container`
- `Transform.translate`

### Input dan Tombol

- `TextField`
- `TextFormField`
- `ElevatedButton`
- `ElevatedButton.icon`
- `InkWell`

### Bottom Navigation

- `BottomNavigationBar`
- `BottomNavigationBarItem`

### Helper Lain

- `showDialog`
- `SnackBar`
- `TextEditingController`
- `GlobalKey<FormState>`

## Catatan Singkat

- Dokumen ini dibuat sebagai catatan pekerjaan hari ini.
- File ini masih berada di workspace dan belum di-commit.
- Kalau nanti ada perubahan tambahan, dokumen ini bisa diperbarui lagi.