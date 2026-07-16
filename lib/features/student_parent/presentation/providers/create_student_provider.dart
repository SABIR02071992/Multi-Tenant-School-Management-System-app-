import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/features/student_parent/data/datasource/create_student_remote_datasource.dart';
import 'package:vidya_setu/features/student_parent/domain/entities/student_entity.dart';
import 'package:vidya_setu/features/student_parent/domain/repositories/create_student_repository.dart';

import '../../../../core/network/dio_client_provider.dart';
import '../../data/repositories/create_student_repositories_impl.dart';
import '../../domain/usecases/create_student_data.dart';

/// Repository Provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/student_entity.dart';
import '../../domain/repositories/create_student_repository.dart';
import '../../domain/usecases/create_student_data.dart';

// -------------------------------
/// Remote DataSource Provider
// -------------------------------
final createStudentRemoteDataSourceProvider =
Provider<CreateStudentRemoteDataSource>((ref) {
  return CreateStudentRemoteDataSource(
    ref.watch(dioClientProvider),
  );
});

// -------------------------------
/// Repository Provider
// -------------------------------
final createStudentRepositoryProvider =
Provider<CreateStudentRepository>((ref) {
  return CreateStudentRepositoryImpl(
    ref.watch(createStudentRemoteDataSourceProvider),
  );
});

// -------------------------------
/// UseCase Provider
// -------------------------------
final createStudentUseCaseProvider =
Provider<CreateStudentData>((ref) {
  return CreateStudentData(
    ref.watch(createStudentRepositoryProvider),
  );
});

// -------------------------------
/// Notifier
// -------------------------------
class CreateStudentNotifier
    extends StateNotifier<AsyncValue<StudentEntity?>> {
  CreateStudentNotifier(this.ref)
      : super(const AsyncData(null));

  final Ref ref;

  Future<StudentEntity?> createStudent(StudentEntity student) async {
    try {
      state = const AsyncLoading();

      final response =
      await ref.read(createStudentUseCaseProvider).call(student);

      state = AsyncData(response);

      return response;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}

// -------------------------------
/// Provider
// -------------------------------
final createStudentProvider = StateNotifierProvider<
    CreateStudentNotifier,
    AsyncValue<StudentEntity?>>((ref) {
  return CreateStudentNotifier(ref);
});