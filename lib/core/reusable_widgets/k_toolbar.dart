import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../theme/app_colors.dart';
import 'logout_alert.dart';

class KAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showLogoutButton;
  final bool showCreateUserButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onCreateUserPressed;
  final Color backgroundColor;
  final bool centerTitle;
  final bool disabled;

  const KAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBackButton = true,
    this.showLogoutButton = false,
    this.showCreateUserButton = false,
    this.onBackPressed,
    this.onCreateUserPressed,
    this.backgroundColor = AppColors.primary,
    this.centerTitle = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: centerTitle,
          automaticallyImplyLeading: false,

          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),

          leading: showBackButton
              ? Padding(
            padding: const EdgeInsets.all(8),
            child: Material(
              color: AppColors.shadowLight,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 16,
                ),
                tooltip: "Back",
                onPressed: onBackPressed ??
                        () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
              ),
            ),
          )
              : null,

          title: Column(
            crossAxisAlignment: centerTitle
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.shadowLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),

          actions: [
            if (actions != null) ...actions!,

            // Create User Button with circular grey background
            if (showCreateUserButton)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Material(
                  color: AppColors.shadowLight,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: IconButton(
                    tooltip: "Create User",
                    icon: const Icon(
                      Icons.person_add,
                      color: Colors.white,
                      size: 18, // आइकॉन का साइज थोड़ा सेट किया है
                    ),
                    onPressed: onCreateUserPressed,
                  ),
                ),
              ),
            // Logout button with circular grey background
            if (showLogoutButton)
              IconButton(
                tooltip: "Logout",
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  AppDialogs.showLogoutDialog(
                    context: context,
                    onLogoutConfirmed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                            (route) => false,
                      );
                    },
                  );
                },
              ),

            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
