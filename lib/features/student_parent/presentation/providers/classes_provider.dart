import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client_provider.dart';
import '../../data/datasource/class_remote_datasource.dart';
import '../../data/repositories/classes_repositories_impl.dart';
import '../../domain/entities/classes_entity.dart';
import '../../domain/repositories/classes_repositories.dart';
import '../../domain/usecases/classes_data.dart';

// Data source provider
final createClassesRemoteDataSourceProvider =
Provider<ClassRemoteDatasource>((ref) {
  return ClassRemoteDatasource(
    ref.watch(dioClientProvider),
  );
});


// Repository Provider
final createClassesRepositoryProvider =
Provider<ClassesRepository>((ref) {
  return ClassesRepositoryImpl(
    ref.watch(createClassesRemoteDataSourceProvider),
  );
});

// UseCase Provider
final createClassesUseCaseProvider =
Provider<ClassesData>((ref) {
  return ClassesData(
    ref.watch(createClassesRepositoryProvider),
  );
});

// Notifier
class CreateClassesNotifier extends StateNotifier<AsyncValue<ClassEntity?>> {
  CreateClassesNotifier(this.ref) : super(const AsyncData(null));

  final Ref ref;

  Future<ClassEntity?> createClasses(ClassEntity classes) async {
    try {
      state = const AsyncLoading();

      final response = await ref.read(createClassesUseCaseProvider).call(classes);

      state = AsyncData(response);
      return response;
    } catch (e, stack) {
      String errorMessage = "Something went wrong";

      // Dio error se exact message nikalne ke liye check
      if (e is DioException) {
        final serverData = e.response?.data;
        if (serverData != null && serverData is Map) {
          errorMessage = serverData['message'] ?? errorMessage;
        } else {
          errorMessage = e.message ?? errorMessage;
        }
      } else {
        errorMessage = e.toString();
      }
      state = AsyncError(errorMessage, stack);
      return null;
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}

class GetClassesNotifier
    extends StateNotifier<AsyncValue<List<ClassEntity>>> {
  GetClassesNotifier(this.ref) : super(const AsyncData([]));

  final Ref ref;

  Future<void> getClasses() async {
    try {
      state = const AsyncLoading();
      await Future.delayed(const Duration(seconds: 2));
      final response = await ref.read(createClassesUseCaseProvider).getClasses();
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
}
// Get All Classes Provider
final getClassesProvider = StateNotifierProvider<
    GetClassesNotifier,
    AsyncValue<List<ClassEntity>>>((ref) {
  return GetClassesNotifier(ref);
});

// Provider
final createClassesProvider = StateNotifierProvider<
    CreateClassesNotifier,
    AsyncValue<ClassEntity?>>((ref) {
  return CreateClassesNotifier(ref);
});