import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasource/people_remote_datasource.dart';
import '../../data/repositories/people_repository_impl.dart';
import '../../domain/entities/people_entity.dart';
import '../../domain/repositories/people_repository.dart';
import '../../domain/usecases/get_people_data.dart';

final peopleRepositoryProvider = Provider<PeopleRepository>((ref) {
  return PeopleRepositoryImpl(
    ref.watch(peopleRemoteDataSourceProvider),
  );
});

/// UseCase Provider
final peopleUseCaseProvider = Provider<GetPeopleData>((ref) {
  return GetPeopleData(
    ref.watch(peopleRepositoryProvider),
  );
});

/// Dashboard StateNotifier
class PeopleNotifier extends StateNotifier<AsyncValue<PeopleEntity>> {
  PeopleNotifier(this.ref) : super(const AsyncLoading()) {
    loadDashboard();
  }

  final Ref ref;

  Future<void> loadDashboard() async {
    try {
      state = const AsyncLoading();

      final data =
      await ref.read(peopleUseCaseProvider).call();

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
final peopleProvider =
StateNotifierProvider<PeopleNotifier, AsyncValue<PeopleEntity>>((ref) {
  return PeopleNotifier(ref);
});