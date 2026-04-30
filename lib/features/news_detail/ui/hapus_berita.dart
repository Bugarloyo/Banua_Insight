import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Menampilkan popup konfirmasi hapus dengan tampilan ala sweet alert.
Future<bool> showHapusBeritaConfirmation(
  BuildContext context, {
  String itemLabel = 'berita ini',
}) async {
  final result = await showGeneralDialog<bool>(
    context: context,
    barrierLabel: 'Konfirmasi Hapus',
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.35),
    transitionDuration: const Duration(milliseconds: 220),
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
                const Text(
                  'Yakin mau hapus?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
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
    transitionBuilder: (_, animation, __, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );

  return result ?? false;
}

Future<void> _showLoadingDeleteDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: Material(
        color: Colors.transparent,
        child: CircularProgressIndicator(color: Color(0xFF336021)),
      ),
    ),
  );
}

Future<void> showDeleteSuccessAlert(
  BuildContext context, {
  String itemLabel = 'Berita',
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 56),
          const SizedBox(height: 10),
          Text(
            '$itemLabel berhasil dihapus',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> showDeleteErrorAlert(BuildContext context, Object error) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Text('Gagal menghapus'),
      content: Text(error.toString()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Tutup'),
        ),
      ],
    ),
  );
}

/// Alur lengkap: konfirmasi -> proses hapus -> notifikasi sukses/gagal.
Future<bool> handleHapusBeritaWithAlert(
  BuildContext context, {
  String itemLabel = 'berita ini',
  required Future<void> Function() onDelete,
}) async {
  final isConfirmed = await showHapusBeritaConfirmation(
    context,
    itemLabel: itemLabel,
  );
  if (!isConfirmed) return false;

  if (!context.mounted) return false;
  _showLoadingDeleteDialog(context);

  try {
    await onDelete();
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      await showDeleteSuccessAlert(context, itemLabel: 'Berita');
    }
    return true;
  } catch (error) {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      await showDeleteErrorAlert(context, error);
    }
    return false;
  }
}
