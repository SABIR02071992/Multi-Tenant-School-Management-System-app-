class SettingsState {
  final bool darkMode;
  final bool notificationEnabled;

  const SettingsState({
    this.darkMode = false,
    this.notificationEnabled = true,
  });

  SettingsState copyWith({
    bool? darkMode,
    bool? notificationEnabled,
  }) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
      notificationEnabled:
      notificationEnabled ?? this.notificationEnabled,
    );
  }
}