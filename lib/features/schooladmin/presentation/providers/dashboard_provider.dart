import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_data.dart';

/// Repository Provider
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    ref.watch(dashboardRemoteDataSourceProvider),
  );
});

/// UseCase Provider
final dashboardUseCaseProvider = Provider<GetDashboardData>((ref) {
  return GetDashboardData(
    ref.watch(dashboardRepositoryProvider),
  );
});

/// Dashboard StateNotifier
class DashboardNotifier extends StateNotifier<AsyncValue<DashboardEntity>> {
  DashboardNotifier(this.ref) : super(const AsyncLoading()) {
    loadDashboard();
  }

  final Ref ref;

  Future<void> loadDashboard() async {
    try {
      state = const AsyncLoading();

      final data =
      await ref.read(dashboardUseCaseProvider).call();

      state = AsyncData(data);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> refresh() async {
    await loadDashboard();
  }
}

/// Dashboard Provider
final dashboardProvider =
StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardEntity>>((ref) {
      return DashboardNotifier(ref);
    });