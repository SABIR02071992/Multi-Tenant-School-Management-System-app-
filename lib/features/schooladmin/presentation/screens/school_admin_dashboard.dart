
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/core/reusable_widgets/k_toolbar.dart';
import 'package:vidya_setu/core/theme/app_colors.dart';
import '../../../../core/reusable_widgets/bottom_nav_menu.dart';
import '../../../../core/reusable_widgets/logout_alert.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../../core/utils/locale_provider.dart';

class SchoolAdminDashboard extends ConsumerStatefulWidget {
  const SchoolAdminDashboard({super.key});

  @override
  ConsumerState<SchoolAdminDashboard> createState() => _SchoolAdminDashboardState();
}

class _SchoolAdminDashboardState extends ConsumerState<SchoolAdminDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ref.watch(localeProvider);

    // 2. Multi-Page Architecture Setup: Aapke Home core dashboard UI ko page array index 0 pr map kiya
    final List<Widget> pages = [
      // Index 0: Home view Dashboard
      SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // वेलकम बैनर
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${l10n.welcome}, Admin!', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text('Apex School Group (Tenant ID: 99)', style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(l10n.selectRole, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
            const SizedBox(height: 12),

            // स्टेट्स ग्रिड
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildAdminCard(l10n.totalStudent, '1,450', Icons.people, AppColors.secondary),
                _buildAdminCard(l10n.totalTeacher, '85', Icons.assignment_ind, AppColors.green),
                _buildAdminCard(l10n.pendingFees, '₹1,20,000', Icons.account_balance_wallet, AppColors.red),
                _buildAdminCard(l10n.activeClass, '24', Icons.door_sliding, AppColors.orange),
              ],
            ),
            const SizedBox(height: 90), // Bottom navigation menu bar padding gap buffer spacing
          ],
        ),
      ),

      // Index 1, 2, 3: Placeholder Screens for tabs
      const Center(child: Text('Analytics View', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
      const Center(child: Text('Alerts View', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
      const Center(child: Text('Settings View', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar:KAppBar(title: l10n.loginTitle,showBackButton: false,showLogoutButton: true,),
      body: Stack(
        children: [
          // Active view space layers
          IndexedStack(
            index: _selectedIndex,
            children: pages,
          ),

          // Modern Floating Custom Bottom Bar UI using Nav constants class
          Positioned(
            left: BottomNavMenu.horizontalPadding,
            right: BottomNavMenu.horizontalPadding,
            bottom: BottomNavMenu.bottomPadding,
            child: Container(
              height: BottomNavMenu.barHeight,
              decoration: BoxDecoration(
                color: BottomNavMenu.navBgColor,
                borderRadius: BorderRadius.circular(BottomNavMenu.barRadius),
                boxShadow: [
                  BoxShadow(
                    color: BottomNavMenu.navBgColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.dashboard_rounded, 'Home'),
                  _buildNavItem(1, Icons.bar_chart_rounded, 'Analytics'),
                  _buildNavItem(2, Icons.notifications_rounded, 'Alerts'),
                  _buildNavItem(3, Icons.settings_rounded, 'Settings'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Custom Nav Tab Component template
  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? BottomNavMenu.activeBgHighlight : Colors.transparent,
          borderRadius: BorderRadius.circular(BottomNavMenu.itemRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? BottomNavMenu.activeColor : BottomNavMenu.inactiveColor,
              size: isSelected ? 26 : 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? BottomNavMenu.activeColor : BottomNavMenu.inactiveColor,
                fontSize: isSelected ? 12 : 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
