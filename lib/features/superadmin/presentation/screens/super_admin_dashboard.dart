import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/core/reusable_widgets/k_toolbar.dart';
import 'package:vidya_setu/core/reusable_widgets/koutline_button.dart';
import 'package:vidya_setu/core/theme/app_colors.dart';
import 'package:vidya_setu/features/superadmin/presentation/screens/schools_edit_delete_screen.dart';
import 'package:vidya_setu/features/superadmin/presentation/screens/super_admin_settings_screen.dart';
import 'package:vidya_setu/features/superadmin/presentation/screens/users_screen.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/reusable_widgets/bottom_nav_menu.dart';
import '../../../../core/reusable_widgets/k_elevatedbutton.dart';
import '../../../../core/reusable_widgets/k_searchable_dropdown.dart';
import '../../../../core/reusable_widgets/logout_alert.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../domain/entity/super_admin_entity.dart';
import '../../../../core/constants/bottom_nav_provider.dart';
import '../../../../core/constants/bottom_nav_visible_provider.dart';
import '../providers/school_onboard_state_provider.dart';
import '../providers/user_provider.dart';
import 'super_admin_home_screen.dart';
import 'onboard_new_school.dart';

class SuperAdminDashboard extends ConsumerStatefulWidget {
  const SuperAdminDashboard({super.key});

  @override
  ConsumerState<SuperAdminDashboard> createState() => _SuperAdminDashboard();
}

class _SuperAdminDashboard extends ConsumerState<SuperAdminDashboard> {
  final titles = [
    "Home",
    "Schools",
    "Users",
    "Settings",
  ];
  final pages = [
    const SuperAdminHomeScreen(),
    const SchoolsScreenForEditDelete(),
    const UsersScreen(),
    const SuperAdminSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ref.watch(localeProvider);
    final isBottomNavVisible = ref.watch(bottomNavVisibleProvider);
    final storage = LocalStorageService();
    final String? user = storage.getUser();
    final String? role = storage.getRole();
    final selectedIndex = ref.watch(bottomNavMenuProvider);
    final isLoading = _disableBottomNavBarAndAppBar(selectedIndex);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KAppBar(
        title:
        titles[selectedIndex],
        showBackButton: false,
        showLogoutButton: true,
        disabled: isLoading,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: selectedIndex,
              children: pages,
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              offset: isBottomNavVisible
                  ? Offset.zero
                  : const Offset(0, 2),
              child: KBottomNavBar(
                currentIndex: selectedIndex,
                disabled: isLoading,
                onTap: (index) {
                  ref.read(bottomNavMenuProvider.notifier).state = index;
                },
                items: const [
                  KBottomNavItem(
                    icon: Icons.dashboard_rounded,
                    label: 'Home',
                  ),
                  KBottomNavItem(
                    icon: Icons.school,
                    label: 'Schools',
                  ),
                  KBottomNavItem(
                    icon: Icons.verified_user,
                    label: 'Users',
                  ),
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
  bool _disableBottomNavBarAndAppBar(int selectedIndex) {
    final homeState = ref.watch(schoolProvider);
    final schoolsState = ref.watch(schoolProvider);
    final usersState = ref.watch(userProvider);

    switch (selectedIndex) {
      case 0:
        return homeState.isLoading;

      case 1:
        return schoolsState.isLoading;

      case 2:
        return usersState.isLoading;

      case 3:
        return false;

      default:
        return false;
    }
  }
}