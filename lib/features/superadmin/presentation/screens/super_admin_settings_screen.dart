import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/k_scrollable_page.dart';
import '../providers/settings_provider.dart';


class SuperAdminSettingsScreen extends ConsumerStatefulWidget {
  const SuperAdminSettingsScreen({super.key});
  @override
  ConsumerState<SuperAdminSettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SuperAdminSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsProvider);

    return state.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),

      error: (e, _) => Center(
        child: Text(e.toString()),
      ),

      data: (settings) {
        return KScrollablePage(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                "Application Settings",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Card(
                color: AppColors.card,
                child: SwitchListTile(
                  value: settings.darkMode,
                  title: const Text("Dark Mode"),
                  subtitle: const Text("Enable dark appearance"),
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .toggleDarkMode(value);
                  },
                ),
              ),

              const SizedBox(height: 12),

              Card(
                color: AppColors.card,
                child: SwitchListTile(
                  value: settings.notificationEnabled,
                  title: const Text("Notifications"),
                  subtitle: const Text("Receive system notifications"),
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .toggleNotification(value);
                  },
                ),
              ),

              const SizedBox(height: 20),

              Card(
                color: AppColors.card,
                child: ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text("Language"),
                  subtitle: const Text("English"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              ),

              const SizedBox(height: 12),

              Card(
                color: AppColors.card,
                child: ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text("Security"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              ),

              const SizedBox(height: 12),

              Card(
                color: AppColors.card,
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text("Profile"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 12),

              Card(
                color: AppColors.card,
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text("Log out"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 12),

              Card(
                color: AppColors.card,
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text("Allow permission"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}