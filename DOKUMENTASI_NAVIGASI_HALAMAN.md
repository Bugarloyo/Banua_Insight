# Dokumentasi Navigasi Halaman Flutter

Panduan singkat untuk pindah halaman di Flutter, baik pakai button biasa maupun bottom navbar.

## 1. Navigasi dengan Button Biasa

Kalau kamu mau pindah halaman dari button, cara yang paling umum adalah pakai `Navigator.push(...)`.

### Contoh

```dart
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HalamanTujuan(),
      ),
    );
  },
  child: const Text('Pindah Halaman'),
)
```

### Kegunaan

- `Navigator.push(...)` = buka halaman baru di atas halaman sekarang.
- `MaterialPageRoute(...)` = membuat transisi perpindahan halaman.
- `context` = dipakai supaya Flutter tahu posisi widget saat navigasi.

## 2. Kembali ke Halaman Sebelumnya

Kalau mau balik ke halaman sebelumnya, pakai `Navigator.pop(context)`.

### Contoh

```dart
IconButton(
  onPressed: () {
    Navigator.pop(context);
  },
  icon: const Icon(Icons.arrow_back),
)
```

### Kegunaan

- `Navigator.pop(context)` = menutup halaman yang aktif sekarang.
- Biasanya dipakai untuk tombol back.

## 3. Ganti Halaman Tanpa Menumpuk Riwayat

Kalau kamu ingin pindah halaman tapi halaman lama tidak mau disimpan di stack, pakai `Navigator.pushReplacement(...)`.

### Contoh

```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => const HalamanBaru(),
  ),
);
```

### Kegunaan

- Cocok untuk login ke home.
- Cocok kalau halaman lama sudah tidak dibutuhkan lagi.

## 4. Hapus Semua Riwayat Lalu Buka Halaman Baru

Kalau kamu mau buka halaman baru dan menghapus semua halaman sebelumnya, pakai `Navigator.pushAndRemoveUntil(...)`.

### Contoh

```dart
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => const HomePage(),
  ),
  (route) => false,
);
```

### Kegunaan

- Biasanya dipakai setelah login atau logout.
- User tidak bisa kembali ke halaman sebelumnya lewat tombol back.

## 5. Kalau Pakai Bottom Navbar

Untuk bottom navbar, cara yang paling rapi biasanya **bukan** `Navigator.push` setiap kali tap menu.
Lebih enak pakai `selectedIndex` lalu tampilkan halaman sesuai index.

### Contoh Sederhana

```dart
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
```

### Kegunaan

- `currentIndex` = item navbar yang sedang aktif.
- `onTap` = menangkap item yang ditekan.
- `setState(...)` = update tampilan halaman.
- `_pages[_selectedIndex]` = menampilkan halaman sesuai menu yang dipilih.

## 6. Kapan Pakai Navigator dan Kapan Pakai Navbar

- Pakai `Navigator.push(...)` kalau tombol itu memang untuk membuka halaman baru.
- Pakai `Navigator.pop(context)` kalau tombol untuk kembali.
- Pakai `BottomNavigationBar` + `selectedIndex` kalau hanya ingin pindah tab/menu utama.

## 7. Yang Dipakai di Project Ini

Di project ini, tombol back seperti di [lib/features/search_news/cari_berita.dart](lib/features/search_news/cari_berita.dart) memakai:

```dart
Navigator.pop(context);
```

Kalau nanti kamu bikin tombol lain untuk pindah halaman, kamu bisa pakai:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const HalamanTujuan()),
);
```

## 8. Command untuk Coba Fitur

Kalau mau lihat hasil perubahan:

1. Jalankan `flutter run`.
2. Buka halaman yang punya button atau navbar.
3. Coba tekan button atau menu navbar.
4. Kalau cuma ubah Dart file, biasanya cukup hot reload.

## 9. Ringkasan Cepat

- `Navigator.push(...)` = pindah ke halaman baru.
- `Navigator.pop(context)` = balik ke halaman sebelumnya.
- `Navigator.pushReplacement(...)` = ganti halaman tanpa simpan halaman lama.
- `BottomNavigationBar` = cocok untuk pindah tab/menu utama.
- `setState(...)` = dipakai untuk update halaman navbar.