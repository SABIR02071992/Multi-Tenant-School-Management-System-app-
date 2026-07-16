import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/features/schooladmin/data/datasource/academics_remote_datasource.dart';
import 'package:vidya_setu/features/schooladmin/domain/usecases/get_academics.dart';

import '../../data/repositories/academics_repository_impl.dart';
import '../../domain/entities/academies_entity.dart';
import '../../domain/repositories/academics_repository.dart';

/// Repository Provider
final academicsRepositoryProvider = Provider<AcademicsRepository>((ref) {
  return AcademicsRepositoryImpl(
    ref.watch(academicsRemoteDataSourceProvider),
  );
});

/// UseCase Provider
final academicsUseCaseProvider = Provider<GetAcademicsData>((ref) {
  return GetAcademicsData(
    ref.watch(academicsRepositoryProvider),
  );
});

/// Academics StateNotifier
class AcademicsNotifier extends StateNotifier<AsyncValue<AcademicsEntity>> {
  AcademicsNotifier(this.ref) : super(const AsyncLoading()) {
    loadAcademics();
  }

  final Ref ref;

  Future<void> loadAcademics() async {
    try {
      state = const AsyncLoading();

      final data =
      await ref.read(academicsUseCaseProvider).call();

      state = AsyncData(data);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> refresh() async {
    await loadAcademics();
  }
}

/// Academics Provider
final academicsProvider =
StateNotifierProvider<AcademicsNotifier, AsyncValue<AcademicsEntity>>((ref) {
  return AcademicsNotifier(ref);
});