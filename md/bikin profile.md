# Dokumentasi Pengerjaan Hari Ini

Tanggal: 10 Mei 2026

## Ringkasan Perubahan

Hari ini saya memperbarui halaman profile supaya lebih informatif dan lebih hidup:

1. Profile sekarang mengambil `username` dari Firestore lewat `AuthService.getCurrentUserData()`.
2. Avatar profile sekarang menampilkan inisial username.
3. Warna background avatar dibuat berubah-ubah berdasarkan username, jadi terlihat random tetapi tetap konsisten untuk user yang sama.
4. Dokumen catatan profile ini diperbarui agar sesuai dengan implementasi terbaru.

## File yang Terdampak

- `lib/features/profile/profile.dart`

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

- Dokumen ini dibuat sebagai catatan perubahan profile hari ini.
- File ini masih berada di workspace dan belum di-commit.
- Kalau nanti ada perubahan tambahan, dokumen ini bisa diperbarui lagi.
