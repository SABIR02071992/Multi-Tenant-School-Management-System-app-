import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/core/reusable_widgets/k_toolbar.dart';
import 'package:vidya_setu/core/theme/app_colors.dart';
import 'package:vidya_setu/features/teacher/presentation/screens/settings_screen.dart';
import 'package:vidya_setu/features/teacher/presentation/screens/student_screen.dart';
import 'package:vidya_setu/features/teacher/presentation/screens/teacher_academics_screen.dart';
import 'package:vidya_setu/features/teacher/presentation/screens/teacher_home_screen.dart';
import '../../../../../core/reusable_widgets/bottom_nav_menu.dart';
import '../../../../../core/utils/local_storage.dart';
import '../../../../../core/utils/locale_provider.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../../../../core/constants/bottom_nav_provider.dart';
import '../../../../../core/constants/bottom_nav_visible_provider.dart';

class TeacherMainScreen extends ConsumerStatefulWidget {
  const TeacherMainScreen({super.key});

  @override
  ConsumerState<TeacherMainScreen> createState() => _TeacherMainScreen();
}

class _TeacherMainScreen extends ConsumerState<TeacherMainScreen> {
  final titles = ["Home", "Student", "Academics", "Settings"];
  // Track scroll position for hide/show
  double _lastScrollOffset = 0;

  final pages = [
    const TeacherHomeScreen(),
    const StudentScreen(),
    const TeacherAcademicsScreen(),
    const TeacherSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ref.watch(localeProvider);
    final isBottomNavVisible = ref.watch(bottomNavVisibleProvider);
    final selectedIndex = ref.watch(bottomNavMenuProvider);
    final storage = LocalStorageService();
    final String? user = storage.getUser();
    final String? role = storage.getRole();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KAppBar(
        title: titles[selectedIndex],
        showBackButton: false,
        showLogoutButton: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                _handleScrollNotification(notification);
                return false;
              },
              child: IndexedStack(index: selectedIndex, children: pages),
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              offset: isBottomNavVisible ? Offset.zero : const Offset(0, 2),
              child: KBottomNavBar(
                currentIndex: selectedIndex,
                onTap: (index) {
                  ref.read(bottomNavMenuProvider.notifier).state = index;
                },
                items: const [
                  KBottomNavItem(icon: Icons.dashboard_rounded, label: 'Home'),
                  KBottomNavItem(icon: Icons.school, label: 'Student'),
                  KBottomNavItem(icon: Icons.verified_user, label: 'Academics'),
                  KBottomNavItem(
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Handle scroll notifications
  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final currentOffset = notification.metrics.pixels;
      final delta = currentOffset - _lastScrollOffset;
      _lastScrollOffset = currentOffset;

      // Only respond to significant scroll changes
      if (delta.abs() > 2) {
        final isScrollingDown = delta > 0;
        final currentVisibility = ref.read(bottomNavVisibleProvider);

        // Hide when scrolling down, show when scrolling up
        if (isScrollingDown && currentVisibility) {
          ref.read(bottomNavVisibleProvider.notifier).state = false;
        } else if (!isScrollingDown && !currentVisibility) {
          ref.read(bottomNavVisibleProvider.notifier).state = true;
        }
      }

      // Show bottom nav when at top of the page
      if (currentOffset <= 0) {
        ref.read(bottomNavVisibleProvider.notifier).state = true;
      }
    }
  }
}
