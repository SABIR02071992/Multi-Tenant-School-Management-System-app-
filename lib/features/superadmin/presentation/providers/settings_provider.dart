import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/features/superadmin/presentation/providers/seetings_notifier.dart';
import 'settings_state.dart';

final settingsProvider = StateNotifierProvider<
    SettingsNotifier,
    AsyncValue<SettingsState>>((ref) {
  return SettingsNotifier();
});