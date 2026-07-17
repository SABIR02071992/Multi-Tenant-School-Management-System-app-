// Data source provider
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/features/student_parent/data/datasource/get_student_remote_datasource.dart';
import 'package:vidya_setu/features/student_parent/data/repositories/get_student_repositories_impl.dart';
import 'package:vidya_setu/features/student_parent/domain/entities/student_entity.dart';
import 'package:vidya_setu/features/student_parent/domain/repositories/get_students_repositories.dart';
import 'package:vidya_setu/features/student_parent/domain/usecases/get_student_data.dart';
import '../../../../core/network/dio_client_provider.dart';

final getStudentsRemoteDataSourceProvider =
Provider<GetStudentRemoteDataSource>((ref) {
  return GetStudentRemoteDataSource(
    ref.watch(dioClientProvider),
  );
});


// Repository Provider
final getStudentRepositoryProvider =
Provider<GetStudentRepository>((ref) {
  return GetStudentRepositoryImpl(
    ref.watch(getStudentsRemoteDataSourceProvider),
  );
});

// UseCase Provider
final getStudentUseCaseProvider =
Provider<GetStudentData>((ref) {
  return GetStudentData(
    ref.watch(getStudentRepositoryProvider),
  );
});

// Notifier
/*class GetStudentNotifier extends StateNotifier<AsyncValue<List<StudentEntity>>> {
  GetStudentNotifier(this.ref) : super(const AsyncData([]));

  final Ref ref;

  Future<void> fetchStudents() async {
    try {
      *//*if (state.hasValue && state.value!.isNotEmpty) {
        return;
      }*//*
      state = const AsyncLoading();
      await Future.delayed(const Duration(seconds: 2));
      final response = await ref.read(getStudentUseCaseProvider).getStudent();
      state = AsyncData(response);

    } catch (e, stack) {
      String errorMessage = "Something went wrong";

      if (e is DioException) {
        final serverData = e.response?.data;

        if (serverData != null && serverData is Map) {
          errorMessage = serverData["message"] ?? errorMessage;
        } else {
          errorMessage = e.message ?? errorMessage;
        }
      } else {
        errorMessage = e.toString();
      }

      state = AsyncError(errorMessage, stack);
    }
  }
  Future<void> refresh() async {
    await fetchStudents();
  }
}*/
class GetStudentNotifier extends StateNotifier<AsyncValue<List<StudentEntity>>> {
  GetStudentNotifier(this.ref) : super(const AsyncData([]));

  final Ref ref;

  /// First Load
  Future<void> fetchStudents() async {
    if (state.hasValue && state.value!.isNotEmpty) {
      return;
    }

    await _loadStudents(showLoader: true);
  }

  /// Pull To Refresh
  Future<void> refresh() async {
    await _loadStudents(showLoader: false);
  }

  Future<void> _loadStudents({required bool showLoader}) async {
    try {
      if (showLoader) {
        state = const AsyncLoading();
      }

      final response =
      await ref.read(getStudentUseCaseProvider).getStudent();

      state = AsyncData(response);
    } catch (e, stack) {
      String errorMessage = "Something went wrong";

      if (e is DioException) {
        final serverData = e.response?.data;

        if (serverData is Map) {
          errorMessage = serverData["message"] ?? errorMessage;
        } else {
          errorMessage = e.message ?? errorMessage;
        }
      } else {
        errorMessage = e.toString();
      }

      state = AsyncError(errorMessage, stack);
    }
  }
}

// Get All Classes Provider
final getStudentProvider = StateNotifierProvider<
    GetStudentNotifier,
    AsyncValue<List<StudentEntity>>>((ref) {
  return GetStudentNotifier(ref);
});
