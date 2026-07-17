import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/core/reusable_widgets/k_toolbar.dart';
import 'package:vidya_setu/core/theme/app_colors.dart';
import 'package:vidya_setu/features/schooladmin/presentation/providers/bottom_nav_provider.dart';
import 'package:vidya_setu/features/schooladmin/presentation/screens/academics_screen.dart';
import 'package:vidya_setu/features/schooladmin/presentation/screens/people_screen.dart';
import 'package:vidya_setu/features/schooladmin/presentation/screens/school_admin_home_screen.dart';
import 'package:vidya_setu/features/schooladmin/presentation/screens/settings_screen.dart';
import 'package:vidya_setu/features/superadmin/domain/entity/super_admin_entity.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/reusable_widgets/bottom_nav_menu.dart';
import '../../../../core/reusable_widgets/k_searchable_dropdown.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../core/constants/bottom_nav_visible_provider.dart';
import '../../../superadmin/presentation/providers/school_onboard_state_provider.dart';
import '../providers/academics_provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/people_provider.dart';
import '../providers/settings_provider.dart';

class SchoolAdminMainScreen extends ConsumerStatefulWidget {
  const SchoolAdminMainScreen({super.key});

  @override
  ConsumerState<SchoolAdminMainScreen> createState() =>
      _SchoolAdminDashboardState();
}

class _SchoolAdminDashboardState extends ConsumerState<SchoolAdminMainScreen> {
  final titles = ["Home", "People", "Academics", "Settings"];
  // Track scroll position for hide/show
  double _lastScrollOffset = 0;
  final pages = [
    const SchoolAdminHomeScreen(),
    const PeopleScreen(),
    const AcademicsScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
   // Dashboard pr first time selected Home tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(schoolAdminBottomNavProvider.notifier).state = 0;
      ref.read(bottomNavVisibleProvider.notifier).state = true;
      ref.read(schoolProvider.notifier).fetchSchoolsList();
    });
  }


  @override
  Widget build(BuildContext context) {
    final isBottomNavVisible = ref.watch(bottomNavVisibleProvider);
    final schoolList = ref.watch(schoolProvider);
    final selectedIndex = ref.watch(schoolAdminBottomNavProvider);
    final storage = LocalStorageService();
    final isLoading = _disableBottomNavBarAndAppBar(selectedIndex);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KAppBar(
        title: titles[selectedIndex],
        showBackButton: false,
        showCreateUserButton: true,
        disabled: isLoading,
        onCreateUserPressed: () async {
          _buildCreateUserLogic(schoolList);

        },
      ),

      body: Stack(
        children: [
          // Main Content with Scroll Detection
          Positioned.fill(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                _handleScrollNotification(notification);
                return false;
              },
              child: IndexedStack(
                index: selectedIndex,
                children: pages,
              ),
            ),
          ),

          // Bottom Navigation Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              offset: isBottomNavVisible ? Offset.zero : const Offset(0, 2),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: isBottomNavVisible ? 1.0 : 0.0,
                child: KBottomNavBar(
                  currentIndex: selectedIndex,
                  disabled: isLoading,
                  onTap: (index) {
                    ref.read(schoolAdminBottomNavProvider.notifier).state = index;
                    // Show bottom nav when changing tabs
                    ref.read(bottomNavVisibleProvider.notifier).state = true;
                  },
                  items: const [
                    KBottomNavItem(icon: Icons.dashboard_rounded, label: 'Home'),
                    KBottomNavItem(icon: Icons.groups_rounded, label: 'People'),
                    KBottomNavItem(icon: Icons.school_rounded, label: 'Academics'),
                    KBottomNavItem(icon: Icons.settings_rounded, label: 'Settings'),
                  ],
                ),
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
  bool _disableBottomNavBarAndAppBar(int selectedIndex) {
    final homeState = ref.watch(dashboardProvider);
    final peopleState = ref.watch(peopleProvider);
    final academicsState = ref.watch(academicsProvider);
    final settingsState = ref.watch(schoolAdminSettingsProvider);

    switch (selectedIndex) {
      case 0:
        return homeState.isLoading;

      case 1:
        return peopleState.isLoading;

      case 2:
        return academicsState.isLoading;

      case 3:
        return settingsState.isLoading;

      default:
        return false;
    }
  }

  void _buildCreateUserLogic(AsyncValue<List<SchoolEntity>> schoolList) {
    schoolList.whenData((schoolList) async {
      if (schoolList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "No schools registered yet! Onboard a school first.",
            ),
          ),
        );
        return;
      }

      final String? selectedDomain = await KSearchableDropdownDialog.show(
        context: context,
        title: "Select School/College",
        items: schoolList,
        itemLabelBuilder: (school) => school.schoolName,
        itemValueBuilder: (school) => school.domain,
      );

      if (selectedDomain != null && context.mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.createSchoolCollegeAdmin,
          arguments: selectedDomain,
        );
      }
    });
  }
}