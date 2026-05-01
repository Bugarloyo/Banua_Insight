# 📋 Dokumentasi Flow Hapus Berita

## 📌 Ringkasan Perubahan
File: `lib/features/news_detail/ui/hapus_berita.dart`

Perubahan fokus pada **fungsi success alert** dan **auto-navigation** setelah data berhasil dihapus.

---

## 🔄 Flow Lengkap Sistem Hapus Berita

```
┌─────────────────────────────────────────────────────────────┐
│ 1. User Klik Tombol Hapus                                   │
│    ↓                                                         │
│    handleHapusBeritaWithAlert() dipanggil                   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 2. Konfirmasi Dialog Muncul                                 │
│    ├─ "Yakin mau hapus?"                                    │
│    ├─ Tombol "Batal" → Kembali (tidak jadi hapus)           │
│    └─ Tombol "Hapus" → Lanjut ke step 3                     │
│    ↓                                                         │
│    showHapusBeritaConfirmation() dengan animasi fade        │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 3. Loading Dialog Muncul                                    │
│    ├─ CircularProgressIndicator                            │
│    ├─ User tidak bisa dismiss                              │
│    └─ Menunggu proses hapus di Firebase...                 │
│    ↓                                                         │
│    _showLoadingDeleteDialog()                               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 4. Proses Hapus di Firebase                                 │
│    ├─ Memanggil onDelete() callback                         │
│    ├─ Data di Firestore/Realtime Database terhapus          │
│    └─ Jika error → catch block (step 7)                     │
│    ↓                                                         │
│    await onDelete()                                         │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 5. Tutup Loading Dialog + Tampilkan Success Alert           │
│    ├─ Loading dialog ditutup                               │
│    ├─ Alert "✓ Berita berhasil dihapus" muncul             │
│    ├─ ❌ TIDAK ADA TOMBOL OK                                 │
│    └─ Alert otomatis ditutup setelah 1.5 detik             │
│    ↓                                                         │
│    showDeleteSuccessAlert() + auto-close                   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 6. Auto-Navigate ke Homepage                                │
│    ├─ Setelah success alert ditutup                        │
│    └─ Langsung kembali ke halaman utama (root route)        │
│    ↓                                                         │
│    Navigator.popUntil((route) => route.isFirst)            │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 7. (JIKA ERROR) Tampilkan Error Alert                       │
│    ├─ Loading dialog ditutup                               │
│    ├─ Alert error menampilkan pesan error                  │
│    ├─ Ada tombol "Tutup"                                    │
│    └─ User masih di halaman detail berita (tidak navigate) │
│    ↓                                                         │
│    showDeleteErrorAlert()                                   │
└─────────────────────────────────────────────────────────────┘
```

---

## 📝 Penjelasan Setiap Fungsi

### 1️⃣ `showHapusBeritaConfirmation()` - Dialog Konfirmasi
**Apa?** Menampilkan dialog konfirmasi dengan tampilan custom (bukan AlertDialog bawaan)

**Komponen:**
- Icon: Delete icon dalam lingkaran hitam
- Text: "Yakin mau hapus?"
- Tombol: "Batal" (outline) | "Hapus" (merah)
- Animasi: Fade + Scale (zoom in)

**Return Value:**
- `true` → User klik "Hapus"
- `false` → User klik "Batal" atau back

---

### 2️⃣ `_showLoadingDeleteDialog()` - Dialog Loading
**Apa?** Menampilkan loading spinner saat proses hapus di Firebase

**Fitur:**
- ❌ User tidak bisa menutup dengan tap barrier
- ✅ Hanya bisa ditutup programatically via `Navigator.pop()`
- Warna: Hijau (#336021)

**Digunakan di:** `handleHapusBeritaWithAlert()` sebelum `onDelete()`

---

### 3️⃣ `showDeleteSuccessAlert()` - Alert Sukses (DIUBAH ✨)
**Apa?** Menampilkan alert ketika data berhasil dihapus

**Yang DIUBAH:**
```
SEBELUM:
- Ada tombol "OK"
- User harus klik OK untuk menutup
- Return type: Future<void> (hanya show dialog)

SESUDAH:
- ❌ TIDAK ADA TOMBOL
- ✅ Auto-close setelah 1.5 detik (1500ms)
- ✅ WillPopScope: User tidak bisa back/dismiss manual
- Return type: async Future<void> (menunggu sampai alert tutup)
```

**Apa yang Terjadi:**
1. Alert ditampilkan dengan icon ✓ hijau + text "Berita berhasil dihapus"
2. `Future.delayed(1500ms)` - Menunggu 1.5 detik
3. `Navigator.pop()` - Alert ditutup otomatis
4. Flow berlanjut ke auto-navigate

**Alasan:**
- UX lebih smooth (tidak perlu user klik OK)
- Alert hanya untuk notifikasi, bukan menunggu action

---

### 4️⃣ `showDeleteErrorAlert()` - Alert Error
**Apa?** Menampilkan error jika proses hapus gagal

**Fitur:**
- Title: "Gagal menghapus"
- Content: Pesan error dari exception
- Ada tombol "Tutup"
- User masih di halaman detail (tidak auto-navigate)

---

### 5️⃣ `handleHapusBeritaWithAlert()` - Main Handler (DIUBAH ✨)
**Apa?** Fungsi utama yang mengatur seluruh flow hapus dari awal sampai akhir

**Parameter:**
- `context` - BuildContext untuk navigation
- `itemLabel` - Label item yang dihapus (default: "berita ini")
- `onDelete` - Callback function untuk hapus data di Firebase

**Flow Step-by-Step:**

```dart
// STEP 1: Tampilkan konfirmasi
final isConfirmed = await showHapusBeritaConfirmation(...);
if (!isConfirmed) return false;  // Jika user batal

// STEP 2: Tampilkan loading
_showLoadingDeleteDialog(context);

// STEP 3-5: Hapus data (try-catch)
try {
  await onDelete();  // <- Panggil function hapus Firebase dari provider/bloc
  
  // STEP 6: Tutup loading
  Navigator.of(context, rootNavigator: true).pop();
  
  // STEP 7: Tampilkan success (dan auto-close di dalamnya)
  await showDeleteSuccessAlert(context, itemLabel: itemLabel);
  
  // STEP 8: Navigate ke homepage
  Navigator.of(context).popUntil((route) => route.isFirst);
  
  return true;
  
} catch (error) {
  // ERROR HANDLING
  Navigator.of(context, rootNavigator: true).pop();  // Tutup loading
  await showDeleteErrorAlert(context, error);  // Tampilkan error
  return false;
}
```

**Yang DIUBAH:**
- `await showDeleteSuccessAlert()` - Sekarang menunggu sampai alert auto-close
- `Navigator.popUntil((route) => route.isFirst)` - Auto-navigate ke homepage
- Comment di komentar berubah dari "notifikasi sukses/gagal" → "notifikasi sukses → kembali ke homepage"

---

## 💡 Cara Menggunakan

### Di Halaman Detail Berita:
```dart
// Contoh implementasi di provider/bloc/controller
onPressed: () async {
  await handleHapusBeritaWithAlert(
    context,
    itemLabel: 'Berita "${judulBerita}"',  // Opsional
    onDelete: () async {
      // Di sini panggil service untuk hapus di Firebase
      await beritaService.deleteBerita(beritaId);
      // Atau jika pakai provider/riverpod:
      // await ref.read(beritaProvider.notifier).deleteBerita(beritaId);
    },
  );
}
```

### Yang Perlu Diperhatikan:
1. **`onDelete()` HARUS menggunakan `await`** - Pastikan proses hapus di Firebase selesai
2. **Firebase Rules** - Update firebase rules agar user bisa hapus dokumen miliknya
3. **Error Handling** - Jika `onDelete()` throw exception, akan masuk ke catch block

---

## 🐛 Debugging Tips

| Situasi | Penyebab | Solusi |
|---------|---------|--------|
| Loading tidak hilang | Exception di `onDelete()` tidak ter-catch | Cek try-catch, pastikan error throw dengan benar |
| Alert tidak tutup | `Future.delayed()` too short | Ubah dari 1500ms jadi lebih lama (misal 2000ms) |
| Navigate gagal (masih di detail) | Context sudah unmounted | Cek `if (context.mounted)` sebelum navigate |
| User bisa tap back saat loading | `barrierDismissible: true` | Sudah `false`, jangan diubah |

---

## 📊 Perbandingan SEBELUM vs SESUDAH

| Aspek | SEBELUM | SESUDAH |
|-------|--------|--------|
| **Success Alert** | Ada tombol OK | ❌ Tidak ada tombol |
| **Success Alert Auto-close** | ❌ Tidak | ✅ 1.5 detik otomatis tutup |
| **Navigation** | Manual (user harus klik OK dulu) | ✅ Otomatis ke homepage |
| **User Experience** | 4 klik: Hapus → Yes → OK → Back | ✅ 2 klik: Hapus → Yes |
| **Return Type** | `Future<void>` (hanya show) | `async Future<void>` (menunggu) |

---

## 🎯 Kesimpulan
Setelah perubahan ini, flow menjadi **lebih cepat dan seamless**:
1. User klik hapus → konfirmasi → loading
2. Data hapus di Firebase
3. Alert sukses muncul + otomatis hilang
4. Auto-navigate ke homepage

**User tidak perlu klik apapun lagi setelah klik "Hapus" di konfirmasi!** ✨
