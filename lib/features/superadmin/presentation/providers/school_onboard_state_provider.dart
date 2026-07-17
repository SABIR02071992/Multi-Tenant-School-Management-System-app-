import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:vidya_setu/features/superadmin/domain/entity/school_college_admin_entity.dart';
import 'dart:convert';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_client_provider.dart';
import '../../data/models/school_model.dart';
import '../../domain/entity/super_admin_entity.dart';

class SchoolNotifier extends StateNotifier<AsyncValue<List<SchoolEntity>>> {
  final Dio _dio;

  SchoolNotifier(this._dio) : super(const AsyncValue.loading());

  /// START ONBOARD SCHOOL METHOD
  Future<void> onboardSchool({
    required String schoolName,
    required String adminEmail,
    required String domain,
    required String planSetup,
    required String logoFilePath,
  }) async {
    /// State ko loading karne se pehle purana data save rakh sakte hain ya direct loading
    state = const AsyncValue.loading();

    try {
      FormData formData = FormData.fromMap({
        "schoolName": schoolName,
        "adminEmail": adminEmail,
        "domain": domain,
        "planSetup": planSetup,
        "logo": await MultipartFile.fromFile(
          logoFilePath,
          filename: logoFilePath.split('/').last,
        ),
      });

      final response = await _dio.post(
        ApiClient.onboardSchool,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseMap = _parseResponse(response.data);
        final schoolData = responseMap['school'];
        final String? message = responseMap['message'];

        if (message != null) {
          log("#SchoolOnboard: $message");
        }

        if (schoolData != null) {
          final newSchool = SchoolModel.fromJson(
            schoolData as Map<String, dynamic>,
          );

          final currentSchools = state.value ?? [];
          state = AsyncValue.data([...currentSchools, newSchool]);
          return;
        }
      }

      state = AsyncValue.error(
        "Received incorrect data from the server!",
        StackTrace.current,
      );
    } on DioException catch (e) {
      state = AsyncValue.error(_handleDioError(e), StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  // FETCH ALL SCHOOLS LIST METHOD
  Future<void> fetchSchoolsList() async {
    state = const AsyncValue.loading();

    try {
      // Clean request URL (Dio options me baseurl set hai to ApiClient.baseUrl hata sakte hain)
      final response = await _dio.get(ApiClient.getAllSchool);
      print("🟢 RESPONSE STATUS CODE: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = _parseResponse(response.data);
        final List<dynamic>? schoolsJson = responseMap['schools'];

        if (schoolsJson != null) {
          final schools = schoolsJson
              .map((json) => SchoolModel.fromJson(json as Map<String, dynamic>))
              .toList();

          state = AsyncValue.data(schools);
          return;
        }
      }
      state = AsyncValue.error(
        "Failed to parse school list from server",
        StackTrace.current,
      );
    } on DioException catch (e) {
      state = AsyncValue.error(_handleDioError(e), StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> refresh() async {
    await fetchSchoolsList();
  }

  /// CREATE SCHOOL/COLLEGE ADMIN USER METHOD
  Future<bool> createSchoolCollegeAdmin({
    required String fullName,
    required String email,
    required String phone,
    required String schoolDomain,
  }) async {
    try {
      // Direct post request payload ke sath
      final response = await _dio.post(
        ApiClient.createSchoolCollegeAdmin,
        // Apne ApiClient ka sahi endpoint check kar lein
        data: {
          "full_name": fullName,
          "email": email,
          "phone": phone,
          "school_domain": schoolDomain,
          "role": "school_college_admin",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(
          "#SchoolAdminCreate: Admin user created and credentials sent to email successfully.",
        );
        return true;
      }
      return false;
    } on DioException catch (e) {
      log("❌ Dio Error in createSchoolCollegeAdmin: ${_handleDioError(e)}");
      return false;
    } catch (e) {
      log("❌ General Error in createSchoolCollegeAdmin: ${e.toString()}");
      return false;
    }
  }

  /// HELPER METHODS (For Clean Code)
  Map<String, dynamic> _parseResponse(dynamic responseData) {
    if (responseData is String) {
      return jsonDecode(responseData);
    } else if (responseData is Map) {
      return Map<String, dynamic>.from(responseData);
    }
    throw const FormatException("Invalid response format received from server");
  }

  String _handleDioError(DioException e) {
    String errorMsg = "Something went wrong!";
    if (e.response?.data != null) {
      dynamic data = e.response!.data;
      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (_) {}
      }
      if (data is Map) {
        errorMsg = data['error'] ?? data['message'] ?? errorMsg;
      } else if (data is String) {
        errorMsg = data;
      }
    } else {
      errorMsg = e.message ?? errorMsg;
    }
    return errorMsg;
  }
}

///  This method is used for add school
final schoolProvider =
    StateNotifierProvider<SchoolNotifier, AsyncValue<List<SchoolEntity>>>((
      ref,
    ) {
      final dio = ref.watch(dioClientProvider);
      return SchoolNotifier(dio);
    });

/// This method is used for getting all schools
final dashboardSchoolsFutureProvider = FutureProvider<List<SchoolEntity>>((
  ref,
) async {
  final notifier = ref.read(schoolProvider.notifier);
  await notifier.fetchSchoolsList();
  return ref.read(schoolProvider).value ?? [];
});
