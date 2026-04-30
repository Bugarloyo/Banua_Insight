import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Dialog konfirmasi hapus dengan custom design (bukan AlertDialog bawaan)
///
/// Features:
/// - Custom border, shadow, dan styling
/// - Icon: Delete icon dalam lingkaran dengan border
/// - Text: "Yakin mau hapus?"
/// - 2 Tombol: "Batal" (outline) dan "Hapus" (merah)
/// - Animasi: Fade + Scale (zoom in smooth)
/// - Tidak bisa dismiss dengan tap barrier (barrierDismissible: false)
///
/// Return Value:
/// - true = User klik "Hapus" → lanjut proses hapus
/// - false = User klik "Batal" atau jarang: tap back
Future<bool> showHapusBeritaConfirmation(
  BuildContext context, {
  String itemLabel = 'berita ini',
}) async {
  final result = await showGeneralDialog<bool>(
    context: context,
    barrierLabel: 'Konfirmasi Hapus',
    barrierDismissible: false, // Tidak bisa dismiss dengan tap luar dialog
    barrierColor: Colors.black.withOpacity(0.35), // Warna gelap di belakang
    transitionDuration: const Duration(milliseconds: 220), // Durasi animasi
    pageBuilder: (dialogContext, _, __) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon: Delete dalam lingkaran hitam
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border(
                      right: BorderSide(color: Colors.black, width: 2),
                      left: BorderSide(color: Colors.black, width: 2),
                      top: BorderSide(color: Colors.black, width: 2),
                      bottom: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  child: const Icon(CupertinoIcons.delete_solid, size: 42),
                ),
                const SizedBox(height: 14),
                // Text: Pertanyaan konfirmasi
                const Text(
                  'Yakin mau hapus?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),
                // Tombol: Batal & Hapus
                Row(
                  children: [
                    // Tombol BATAL (Outline)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE0E0E0)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7F7F7F),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Tombol HAPUS (Filled Merah)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Hapus',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
    // Animasi: Fade + Scale (smooth zoom in)
    transitionBuilder: (_, animation, __, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved, // Fade in
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1).animate(curved), // Zoom in
          child: child,
        ),
      );
    },
  );

  return result ?? false; // Default false jika dismiss tanpa tombol
}

/// Dialog loading yang ditampilkan saat proses hapus berjalan
///
/// Features:
/// - Loading spinner warna hijau (#336021)
/// - Dialog transparent
/// - ❌ Tidak bisa dismiss dengan back atau tap barrier
/// - Hanya bisa ditutup programmatically dengan Navigator.pop()
///
/// Digunakan di: handleHapusBeritaWithAlert() sebelum onDelete()
Future<void> _showLoadingDeleteDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User tidak bisa dismiss dengan back/tap
    builder: (_) => const Center(
      child: Material(
        color: Colors.transparent,
        child: CircularProgressIndicator(color: Color(0xFF336021)),
      ),
    ),
  );
}

/// ✨ DIUBAH: Menampilkan alert sukses dengan tombol OK untuk navigate
///
/// Fitur:
/// - Dialog ditampilkan dengan icon ✓ hijau
/// - ✅ ADA TOMBOL OK (navigate ke homepage)
/// - User tidak bisa dismiss dengan back/tap barrier (WillPopScope)
/// - Tombol OK akan menutup dialog + navigate ke halaman homepage
///
/// Alasan perubahan:
/// - Lebih reliable daripada auto-navigate
/// - User punya control dan harus confirm sebelum navigate
/// - Trigger navigasi dari tombol langsung ke homepage
Future<void> showDeleteSuccessAlert(
  BuildContext context, {
  String itemLabel = 'Berita',
}) {
  // Tampilkan dialog
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User tidak bisa tap barrier untuk tutup
    builder: (dialogContext) => WillPopScope(
      // WillPopScope: Prevent user dari back/dismiss manual
      onWillPop: () async => false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon sukses (lingkaran hijau dengan centang)
            const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 56),
            const SizedBox(height: 10),
            // Text: "Berita berhasil dihapus"
            Text(
              '$itemLabel berhasil dihapus',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          // Tombol OK: tutup dialog lalu navigate ke homepage
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Kemudian navigate ke homepage (route pertama)
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Dialog error yang ditampilkan jika proses hapus gagal
///
/// Features:
/// - Title: "Gagal menghapus"
/// - Content: Pesan error dari exception
/// - Tombol: "Tutup" (user harus klik untuk menutup)
/// - Dialog bisa dismiss dengan back/tap barrier
///
/// Kondisi: Jika onDelete() throw exception di handleHapusBeritaWithAlert()
/// User tetap di halaman detail (tidak auto-navigate)
Future<void> showDeleteErrorAlert(BuildContext context, Object error) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // User bisa dismiss dengan back/tap
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Text('Gagal menghapus'),
      content: Text(error.toString()), // Pesan error dari exception
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Tutup'),
        ),
      ],
    ),
  );
}

/// ✨ DIUBAH: Alur lengkap hapus berita dengan tombol navigate
///
/// Flow:
/// 1. Tampilkan dialog konfirmasi
/// 2. Jika user confirm, tampilkan loading dialog
/// 3. Jalankan onDelete() untuk hapus di Firebase
/// 4. Jika sukses: tutup loading → tampilkan success alert dengan tombol OK
/// 5. User klik OK di alert → navigate ke homepage (handle di showDeleteSuccessAlert)
/// 6. Jika error: tutup loading → tampilkan error alert
///
/// Return: true jika sukses, false jika error atau batal
Future<bool> handleHapusBeritaWithAlert(
  BuildContext context, {
  String itemLabel = 'berita ini',
  required Future<void> Function() onDelete,
}) async {
  // ========== STEP 1: Tampilkan Konfirmasi Dialog ==========
  // Menunggu user memilih "Hapus" atau "Batal"
  final isConfirmed = await showHapusBeritaConfirmation(
    context,
    itemLabel: itemLabel,
  );

  // Jika user batal, langsung return false (tidak jadi hapus)
  if (!isConfirmed) return false;

  // Validasi context masih valid sebelum lanjut
  if (!context.mounted) return false;

  // ========== STEP 2: Tampilkan Loading Dialog ==========
  // CircularProgressIndicator muncul, user tidak bisa dismiss
  _showLoadingDeleteDialog(context);

  try {
    // ========== STEP 3: Hapus Data di Firebase ==========
    // onDelete() adalah callback dari provider/bloc untuk hapus Firestore/Realtime DB
    // Contoh di provider:
    //   onDelete: () => firebaseService.deleteBerita(beritaId)
    await onDelete();

    // ========== STEP 4A: Sukses - Tutup Loading ==========
    // Validasi context sebelum navigate
    if (context.mounted) {
      // Tutup loading dialog dengan rootNavigator=true
      // (penting karena loading dialog di-push ke root navigator)
      Navigator.of(context, rootNavigator: true).pop();

      // ========== STEP 4B: Tampilkan Success Alert dengan Tombol OK ==========
      // showDeleteSuccessAlert() menampilkan dialog dengan tombol OK
      // Tombol OK akan handle navigasi ke homepage
      await showDeleteSuccessAlert(context, itemLabel: itemLabel);

      // Setelah dialog ditutup (user klik OK), user sudah di homepage
      // Tidak perlu navigate manual di sini
    }
    return true; // Sukses
  } catch (error) {
    // ========== STEP 5: Error - Tampilkan Error Alert ==========
    // Jika onDelete() throw exception, masuk ke sini

    if (context.mounted) {
      // Tutup loading dialog
      Navigator.of(context, rootNavigator: true).pop();

      // Tampilkan error dialog (user harus klik "Tutup")
      // User tetap di halaman detail (tidak navigate)
      await showDeleteErrorAlert(context, error);
    }
    return false; // Gagal
  }
}
