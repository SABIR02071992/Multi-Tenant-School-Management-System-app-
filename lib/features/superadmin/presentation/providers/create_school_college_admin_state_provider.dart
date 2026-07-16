
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/features/superadmin/domain/entity/school_college_admin_entity.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_client_provider.dart';

/*class SchoolCollegeAdminNotifier extends StateNotifier<AsyncValue<List<SchoolCollegeAdminEntity>>> {
  final Dio _dio;

  SchoolCollegeAdminNotifier(this._dio) : super(const AsyncValue.loading());

  /// CREATE SCHOOL/COLLEGE ADMIN USER METHOD
  Future<bool> createNewUserForSchoolCollegeAdmin({
    required String fullName,
    required String email,
    required String phone,
    required String schoolDomain,
  }) async {
    try {
      // Direct post request payload ke sath
      final response = await _dio.post(
        ApiClient.createSchoolCollegeAdmin,
        data: {
          "full_name": fullName,
          "email": email,
          "phone": phone,
          "school_domain": schoolDomain,
          "role": "School/College Admin",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("#SchoolAdminCreate: Admin user created and credentials sent to email successfully.");
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



/// Create school/college admin user
final schoolCollegeAdminProvider =
StateNotifierProvider<SchoolCollegeAdminNotifier, AsyncValue<List<SchoolCollegeAdminEntity>>>((
    ref,
    ) {
  final dio = ref.watch(dioClientProvider);
  return SchoolCollegeAdminNotifier(dio);
});*/
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_snackbar.dart';

// Aapki local entities aur client paths ke mutabik imports check karein
// import 'package:your_app/models/school_college_admin_entity.dart';
// import 'package:your_app/core/api_client.dart';

class SchoolCollegeAdminNotifier extends StateNotifier<AsyncValue<List<SchoolCollegeAdminEntity>>> {
  final Dio _dio;

  // Initial state ko data empty list ke sath set kiya taaki first time UI crash na ho
  SchoolCollegeAdminNotifier(this._dio) : super(const AsyncValue.data([]));

  /// CREATE SCHOOL/COLLEGE ADMIN USER METHOD
  Future<String?> createNewUserForSchoolCollegeAdmin({
    required String fullName,
    required String email,
    required String phone,
    required String schoolDomain,
    required String password,
    required String role,
  }) async {
    // 🟢 1. UI Loading Toggle Layer Active kiya
    state = const AsyncValue.loading();

    try {
      // 🟢 2. Flask Backend API Keys Verification mapping setup
      final Map<String, dynamic> requestPayload = {
        "name": fullName,                  // Flask backend: data.get('name')
        "email": email,                    // Flask backend: data.get('email')
        "mobile": phone,                   // Flask backend: data.get('mobile')
        "school_domain": schoolDomain,     // Flask backend: data.get('school_domain')
        "password": password, // Flask backend: data.get('password') [Mandatory]
        "role": role,                      // Flask backend: data.get('role')
      };

      final response = await _dio.post(
        ApiClient.createSchoolCollegeAdmin,
        data: requestPayload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {

        state = const AsyncValue.data([]);
        return response.data['message'] ?? "Admin successfully created!";

      }

      state = const AsyncValue.data([]);
      return "Failed to create user. Server responded with status: ${response.statusCode}";
    } on DioException catch (e) {
      final String parsedError = _handleDioError(e);
      log("❌ Dio Error in createSchoolCollegeAdmin: $parsedError");

      // Error hone pr state ko fallback custom data status me maintain rakha
      state = AsyncValue.error(parsedError, StackTrace.current);
      return parsedError; // Return actual error text to display in snackbar
    } catch (e) {
      log("❌ General Error in createSchoolCollegeAdmin: ${e.toString()}");
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return e.toString();
    }
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

/// Create school/college admin user global provider index
final createUser =
StateNotifierProvider<SchoolCollegeAdminNotifier, AsyncValue<List<SchoolCollegeAdminEntity>>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return SchoolCollegeAdminNotifier(dio);
});
