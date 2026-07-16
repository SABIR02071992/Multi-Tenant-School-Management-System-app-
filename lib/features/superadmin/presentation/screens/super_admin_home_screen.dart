import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/reusable_widgets/k_custom_loader.dart';
import '../../../../core/reusable_widgets/k_error_widget.dart';
import '../../../../core/reusable_widgets/k_searchable_dropdown.dart';
import '../../../../core/reusable_widgets/koutline_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entity/super_admin_entity.dart';
import '../providers/school_onboard_state_provider.dart';

class SuperAdminHomeScreen extends ConsumerStatefulWidget {
  const SuperAdminHomeScreen({super.key});

  @override
  ConsumerState<SuperAdminHomeScreen> createState() =>
      _SuperAdminHomeScreenState();
}

class _SuperAdminHomeScreenState extends ConsumerState<SuperAdminHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(schoolProvider.notifier).fetchSchoolsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final schoolsAsync = ref.watch(schoolProvider);
    return schoolsAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: KCustomLoader(
            message: 'Loading...',
          ),
        ),
      ),

      error: (error, stack) => Scaffold(
        body: KErrorWidget(
          title: "Failed to load academics",
          message: error.toString(),
          onRetry: () {
            ref.read(schoolProvider.notifier).refresh();
          },
        ),
      ),

      data: (data) {
        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(schoolProvider.notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      KOutlinedButton(
                        label: 'Create School Admin',
                        backgroundColor: AppColors.card,
                        icon: Icons.add,
                        onPressed: () async {
                          schoolsAsync.whenData((schoolList) async {
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

                            final String? selectedDomain =
                            await KSearchableDropdownDialog.show(
                              context: context,
                              title: "Select School/College",
                              items: schoolList,
                              itemLabelBuilder: (school) =>
                              school.schoolName,
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
                        },
                      ),
                    ],
                  ),
                ),

                Text(
                  l10n.globalOverview,
                  style: const TextStyle(
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
                  children: [
                    _buildSAStatCard(
                      l10n.totalRegisterSchool,
                      _getSchoolsCountString(schoolsAsync),
                      Icons.business,
                      AppColors.info,
                          () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.allRegisterSchools,
                        );
                      },
                    ),
                    _buildSAStatCard(
                      l10n.activeSubscription,
                      '38',
                      Icons.card_membership,
                      AppColors.warning,
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),

                const SizedBox(height: 12),

                KOutlinedButton(
                  label: '${l10n.newSchoolOnboard} (Add New School)',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.schoolSetup);
                  },
                  icon: Icons.add_business,
                  borderColor: AppColors.primary,
                  backgroundColor: AppColors.card,
                  borderRadius: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      color: AppColors.card,
      child: InkWell(
        onTap: onTap,
        splashColor: color.withOpacity(0.1),
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
                style: const TextStyle(fontSize: 12, color: AppColors.textHint),
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
