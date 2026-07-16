import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/features/schooladmin/data/datasource/settings_remote_datasource.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settinge_repository.dart';
import '../../domain/usecases/get_settings_data.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(
    ref.watch(settingsRemoteDataSourceProvider),
  );
});

/// UseCase Provider
final settingsUseCaseProvider = Provider<GetSettingsData>((ref) {
  return GetSettingsData(
    ref.watch(settingsRepositoryProvider),
  );
});

/// Dashboard StateNotifier
class SettingsNotifier extends StateNotifier<AsyncValue<SettingsEntity>> {
  SettingsNotifier(this.ref) : super(const AsyncLoading()) {
    loadSettings();
  }

  final Ref ref;

  Future<void> loadSettings() async {
    try {
      state = const AsyncLoading();

      final data =
      await ref.read(settingsUseCaseProvider).call();

      state = AsyncData(data);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> refresh() async {
    await loadSettings();
  }
}

/// Dashboard Provider
final schoolAdminSettingsProvider =
StateNotifierProvider<SettingsNotifier, AsyncValue<SettingsEntity>>((ref) {
  return SettingsNotifier(ref);
});