import 'package:flutter/material.dart';

import '../../main.dart';
import '../network/internet_service.dart';

bool _isDialogShowing = false;

void showNoInternetDialog() {
  if (_isDialogShowing) return;

  final context = navigatorKey.currentContext;

  if (context == null) return;

  _isDialogShowing = true;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    color: Colors.red.shade400,
                    size: 45,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "No Internet Connection",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                Text(
                  "Please check your internet connection and try again.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final connected =
                      await InternetService.instance.hasInternet();

                      if (connected) {
                        hideNoInternetDialog();
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      "Retry",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void hideNoInternetDialog() {
  if (!_isDialogShowing) return;

  final context = navigatorKey.currentContext;

  if (context != null && Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }

  _isDialogShowing = false;
}