import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/core/theme/app_colors.dart';
import '../../../../core/reusable_widgets/k_dropdown.dart';
import '../../../../core/reusable_widgets/k_searchable_dropdown.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../superadmin/presentation/providers/school_onboard_state_provider.dart';

class SelectCollegeScreen extends ConsumerStatefulWidget {
  const SelectCollegeScreen({super.key});

  @override
  ConsumerState<SelectCollegeScreen> createState() => _SelectCollegeScreenState();
}

class _SelectCollegeScreenState extends ConsumerState<SelectCollegeScreen> {
  List<dynamic> _allSchools = [];
  dynamic _selectedSchool;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadSchools);
  }

  Future<void> _loadSchools() async {
    try {
      final schools = await ref.read(dashboardSchoolsFutureProvider.future);
      if (!mounted) return;
      setState(() {
        _allSchools = schools;
      });
    } catch (e) {
      debugPrint("Error loading schools : $e");
    }
  }

  // 🟢 Custom Search Dialog trigger karne ka function
  void _openSearchableDialog() async {
    if (_allSchools.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No schools registered yet!")),
      );
      return;
    }

    final String? selectedDomain = await KSearchableDropdownDialog.show<dynamic>(
      context: context,
      title: "Select School / College",
      items: _allSchools,
      itemLabelBuilder: (school) => school.schoolName,
      itemValueBuilder: (school) => school.domain,
      initialValue: _selectedSchool?.domain,
    );

    if (selectedDomain != null && mounted) {
      setState(() {
        // Domain matching object find karke set karenge
        _selectedSchool = _allSchools.firstWhere((school) => school.domain == selectedDomain);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final schoolState = ref.watch(schoolProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.scaffold, // 🟢 Theme consistency
      body: SafeArea(
        child: schoolState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary, // 🟢 Theme matching spinner
            ),
          ),
          error: (error, _) => Center(
            child: Text("${l10n.error}: $error", style: const TextStyle(color: AppColors.red)),
          ),
          data: (_) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.school_rounded,
                  size: 70,
                  color: AppColors.primary, // 🟢 Soft premium look
                ),
                const SizedBox(height: 16),
                const Text(
                  "Select School / College",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 35),

                /// 🟢 YOUR CUSTOM DESIGNED KDROWDOWN FIELD
                // Tap karne par yeh field dialog trigger karegi
                InkWell(
                  onTap: _openSearchableDialog,
                  borderRadius: BorderRadius.circular(8),
                  child: IgnorePointer(
                    child: KDropdown(
                      labelText: "Choose College",
                      hintText: "Select School",
                      value: _selectedSchool?.schoolName, // UI me selected school ka naam dikhane ke liye
                      prefixIcon: Icons.account_balance_rounded,
                      items: _selectedSchool != null ? [_selectedSchool.schoolName] : [],
                      onChanged: (_) {},
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // 🟢 AppColors layout matching ElevateButton
                ElevatedButton(
                  onPressed: _selectedSchool == null
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(
                          schoolDomain: _selectedSchool.domain,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.border, // Disabled state logic
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: _selectedSchool == null ? AppColors.textHint : AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Are you a Super Admin? ",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(
                              schoolDomain: null,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Login Here",
                        style: TextStyle(
                          color: AppColors.secondary, // 🟢 Indigo link highlight matching branding
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
