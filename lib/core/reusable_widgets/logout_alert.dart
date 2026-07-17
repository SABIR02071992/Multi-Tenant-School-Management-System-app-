import 'package:flutter/material.dart';

import '../constants/route_constants.dart';
import '../theme/app_colors.dart';
import '../utils/local_storage.dart';

class AppDialogs {
  // Static method jise app me kahin bhi call kiya ja sake
  static void showLogoutDialog({
    required BuildContext context,
    required VoidCallback onLogoutConfirmed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildDialogContent(context, onLogoutConfirmed),
        );
      },
    );
  }

  // Dialog ka UI design structure
  static Widget _buildDialogContent(BuildContext context, VoidCallback onLogoutConfirmed) {
    final storage = LocalStorageService();
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: AppColors.black,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon Anchor
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.logout_rounded,
              color: AppColors.red,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),

          // Title
          const Text(
            "Logout?",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle text
          const Text(
            "Are you sure you want to log out of your account?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons Row
          Row(
            children: [
              // Cancel Button
              Expanded(
                child: OutlinedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.textHint),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              /// Logout Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    storage.logout();
                    print("#Token: ${storage.getToken()}");
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, AppRoutes.selectCollegeScreen,);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
