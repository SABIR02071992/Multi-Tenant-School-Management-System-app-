import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_state.dart';

class SettingsNotifier extends StateNotifier<AsyncValue<SettingsState>> {
  SettingsNotifier()
      : super(
    const AsyncValue.data(SettingsState()),
  );

  void toggleDarkMode(bool value) {
    final current = state.value;
    if (current == null) return;

    state = AsyncValue.data(
      current.copyWith(
        darkMode: value,
      ),
    );
  }

  void toggleNotification(bool value) {
    final current = state.value;
    if (current == null) return;

    state = AsyncValue.data(
      current.copyWith(
        notificationEnabled: value,
      ),
    );
  }
}