import 'package:flutter/material.dart';

class AppSnackBar {
  AppSnackBar._(); // Private constructor to prevent instantiation

  // 🟢 Pure Native Success Snackbar
  static void showSuccessSnackBar({
    required BuildContext context, // Custom context layer target
    required String title,
    required String message,
  }) {
    // Purane chal rahe saare snackbars ko instant clear karein
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(message, style: const TextStyle(fontSize: 12, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green, // AppColors.green use karein
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // 🔴 Pure Native Error Snackbar
  static void showErrorSnackBar({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(message, style: const TextStyle(fontSize: 12, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red, // AppColors.red use karein
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
