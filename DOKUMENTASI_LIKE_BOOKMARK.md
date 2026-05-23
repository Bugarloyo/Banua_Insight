# Dokumentasi Like & Bookmark

## Alur Singkat

- Tombol like dan bookmark ada di halaman detail berita.
- Like disimpan ke koleksi Firestore `likes`.
- Bookmark / save disimpan ke koleksi Firestore `bookmarks`.
- Halaman `Simpan` membaca semua data bookmark user login lalu menampilkannya.

## Field Firestore

### `likes`

- `id_user` -> `int`
- `id_berita` -> `int`
- `created_at` -> `Timestamp`

### `bookmarks`

- `id_user` -> `int`
- `id_berita` -> `int`
- `created_at` -> `Timestamp`

## Command yang Dipakai

Jalankan app web:

```bash
flutter run -d chrome
```

Lihat device yang terhubung:

```bash
flutter devices
```

Jalankan app ke emulator / HP:

```bash
flutter run -d <device-id>
```

Periksa koneksi Flutter ke Android:

```bash
flutter doctor -v
```

Terima lisensi Android jika diminta:

```bash
flutter doctor --android-licenses
```

## Catatan

- Bookmark hanya tampil jika user sedang login.
- Jika gambar berita tidak muncul, pastikan URL di field `img_url` valid dan bisa dibuka langsung di browser.