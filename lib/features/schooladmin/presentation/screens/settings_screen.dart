import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/reusable_widgets/k_custom_loader.dart';
import '../../../../core/reusable_widgets/k_error_widget.dart';
import '../../../../core/reusable_widgets/logout_alert.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_font_sizes.dart';
import '../../../../core/utils/icon_mapper.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../superadmin/presentation/providers/settings_provider.dart';
import '../../domain/entities/settings_entity.dart';
import '../providers/academics_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final academicsState = ref.watch(schoolAdminSettingsProvider);
    return academicsState.when(
      loading: () => const Center(child: KCustomLoader(message: 'Loading...',)),
      error: (error, stack) => KErrorWidget(
        title: "Failed to load academics",
        message: error.toString(),
        onRetry: () {
          ref.read(schoolAdminSettingsProvider.notifier).refresh();
        },
      ),
      data: (data) {
        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(schoolAdminSettingsProvider.notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildMenu(data)],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfile(SettingsEntity data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My Profile",
          style: TextStyle(
            fontSize: AppFontSizes.heading4,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        _ProfileCard(profile: data.profile),
      ],
    );
  }

  Widget _buildMenu(SettingsEntity data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //const Text("Settings", style: TextStyle(fontSize: AppFontSizes.heading4, fontWeight: FontWeight.bold,),),
        const SizedBox(height: 15),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.menus.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            return _MenuCard(menu: data.menus[index]);
          },
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final ProfileEntity profile;

  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: AppColors.border),

        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: AppColors.primary.withOpacity(.12),
            child: const Icon(Icons.person, color: AppColors.primary, size: 38),
          ),

          const SizedBox(height: 15),

          Text(
            profile.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppFontSizes.heading4,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            profile.role,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppFontSizes.bodyMedium,
            ),
          ),

          const SizedBox(height: 18),

          const Divider(),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.email_outlined, color: AppColors.primary),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  profile.email,
                  style: const TextStyle(fontSize: AppFontSizes.bodyMedium),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final MenuEntity menu;

  const _MenuCard({required this.menu});

  @override
  Widget build(BuildContext context) {
    final bool isLogout = menu.route == "logout";

    final Color color = isLogout ? AppColors.red : AppColors.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(18),

      onTap: () {
        switch (menu.route) {
          case "profile":
            break;

          case "school_profile":
            break;

          case "change_password":
            break;

          case "logout":
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
            break;
        }
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),

        decoration: BoxDecoration(
          color: AppColors.white,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(color: AppColors.border),

          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                shape: BoxShape.circle,
              ),

              child: Icon(IconMapper.getIcon(menu.icon), color: color),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                menu.title,
                style: TextStyle(
                  fontSize: AppFontSizes.bodyLarge,
                  fontWeight: FontWeight.w600,
                  color: isLogout ? AppColors.red : AppColors.textPrimary,
                ),
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
