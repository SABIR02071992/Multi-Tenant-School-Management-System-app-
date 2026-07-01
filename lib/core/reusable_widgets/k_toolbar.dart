import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color backgroundColor;
  final bool centerTitle;

  const KAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor = const Color(0xFF0F172A), // Premium Dark Slate Blue
    this.centerTitle = false, // Standard corporate UI defaults to left-aligned
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      // Clean flat look bina gande shadows ke
      scrolledUnderElevation: 0,
      // Prevent color change on scrolling lists
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,

      // Status Bar brightness and color management
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // White icons in status bar
        statusBarBrightness: Brightness.dark, // For iOS support
      ),

      // Premium Backward Arrow Layout with perfect padding bounds
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.white.withOpacity(0.06),
                // Subtle inner circle highlight
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 16,
                  ),
                  tooltip: 'Back',
                  onPressed:
                      onBackPressed ??
                      () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                ),
              ),
            )
          : null,

      // Flexible Title & Subtitle structure for descriptive headers
      title: Column(
        crossAxisAlignment: centerTitle
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              // Medium bold style for modern screens
              color: Colors.white,
              letterSpacing: -0.3, // Clean compact letter kerning
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.6),
                // Muted crisp visual hierarchy
                letterSpacing: 0.1,
              ),
            ),
          ],
        ],
      ),

      // Flexible Action Row spacing
      actions: actions != null
          ? [
              ...actions!,
              const SizedBox(width: 8), // Standard trailing end gap
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
