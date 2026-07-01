import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/core/theme/app_colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/reusable_widgets/k_elevatedbutton.dart';
import '../../../../core/reusable_widgets/logout_alert.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../domain/entity/super_admin_entity.dart';
import '../providers/school_onboard_state_provider.dart';
import 'onboard_new_school.dart';

class SuperAdminDashboard extends ConsumerStatefulWidget {
  const SuperAdminDashboard({super.key});

  @override
  ConsumerState<SuperAdminDashboard> createState() => _SuperAdminDashboard();
}

class _SuperAdminDashboard extends ConsumerState<SuperAdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ref.watch(localeProvider);
    final schoolsAsync = ref.watch(dashboardSchoolsFutureProvider);
    final storage = LocalStorageService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.uperAdmin,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AppDialogs.showLogoutDialog(
                context: context,
                onLogoutConfirmed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.globalOverview,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,

              /// pass the dynamic data here
              children: [
                _buildSAStatCard(
                  l10n.totalRegisterSchool,
                  _getSchoolsCountString(schoolsAsync),
                  Icons.business,
                  AppColors.info,
                  () {
                    Navigator.pushNamed(context, AppRoutes.allRegisterSchools);
                  },
                ),
                _buildSAStatCard(
                  l10n.activeSubscription,
                  '38',
                  Icons.card_membership,
                  AppColors.gold,
                  () {},
                ),
                _buildSAStatCard(
                  l10n.monthlyRevenue,
                  '₹4,50,000',
                  Icons.monetization_on,
                  AppColors.green,
                  () {},
                ),
                _buildSAStatCard(
                  l10n.systemAlert,
                  '02',
                  Icons.warning,
                  AppColors.orange,
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 24),

            Text(
              l10n.quickAction,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.schoolSetup);
              },
              icon: const Icon(Icons.add_business),
              label: Text('${l10n.newSchoolOnboard} (Add New School)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            KElevatedButton(
              label: 'Create School Admin',
              icon: Icons.supervised_user_circle_outlined,
              onPressed: () {
                // 1. Check karein ki data successfully loaded hai ya nahi
                schoolsAsync.whenData((schoolList) {
                  if (schoolList.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No schools registered yet! Onboard a school first.")),
                    );
                    return;
                  }

                  // 2. Dialog open karein jo dropdown dikhaye
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String? selectedDomain = schoolList.first.domain; // Default select first item

                      return AlertDialog(
                        title: const Text("Select School/College", style: TextStyle(fontWeight: FontWeight.bold)),
                        content: StatefulBuilder(
                          builder: (context, setDialogState) {
                            return DropdownButtonFormField<String>(
                              value: selectedDomain,
                              isExpanded: true,
                              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Choose Institution',contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),),
                              items: schoolList.map((school) {
                                return DropdownMenuItem<String>(
                                  value: school.domain, // 🟢 Dynamic domain id map ho rhi hai
                                  child: Text(school.schoolName,overflow: TextOverflow.ellipsis,maxLines: 2,), // School ka name UI me dikhega
                                );
                              }).toList(),
                              onChanged: (value) {
                                setDialogState(() {
                                  selectedDomain = value;
                                });
                              },
                            );
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                              // 3. Target screen pr navigate karein dynamic domain ke sath
                              Navigator.pushNamed(
                                context,
                                AppRoutes.createSchoolCollegeAdmin,
                                arguments: selectedDomain, // 🟢 Dynamic ID successfully forward ho gayi
                              );
                            },
                            child: const Text("Proceed", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      );
                    },
                  );
                });
              },
            )
          ],
        ),
      ),
    );
  }

  /// ==========================================
  /// HELPER METHODS (For Clean Code)
  /// ==========================================
  String _getSchoolsCountString(AsyncValue<List<SchoolEntity>> asyncSchools) {
    return asyncSchools.when(
      data: (schoolList) => schoolList.length.toString(),
      loading: () => "Loading....",

      error: (err, stack) {
        print("❌ Riverpod Error: $err");
        return "Error";
      },
    );
  }

  Widget _buildSAStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      // 🔥 Yeh ripple effect ko rounded corners ke bahar nahi jaane dega
      child: InkWell(
        onTap: onTap,
        // 🔥 Aapka click action yahan execute hoga
        splashColor: color.withOpacity(0.1),
        // Card ke color jaisa light ripple effect
        highlightColor: color.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
