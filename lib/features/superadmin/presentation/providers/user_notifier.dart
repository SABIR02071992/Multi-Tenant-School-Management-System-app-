import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/features/auth/domain/entities/user_entity.dart';

import '../../../../core/network/api_client.dart';
import '../../../auth/data/models/user_model.dart';

class UserNotifier extends StateNotifier<AsyncValue<List<UserEntity>>> {
  final Dio _dio;

  UserNotifier(this._dio) : super(const AsyncValue.loading());

  Future<void> fetchAllRegisterUsers() async {
    state = const AsyncValue.loading();
    try {
      final response = await _dio.get(ApiClient.getAllUsersForSuperAdmin);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = _parseResponse(response.data);
        final List<dynamic>? usersJson = responseMap['users'];
        if (usersJson != null) {
          final users = usersJson
              .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
              .toList();
          state = AsyncValue.data(users);
          return;
        }

      } else {
      }
    } on DioException catch (e) {
      state = AsyncValue.error(_handleDioError(e), StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
  Future<void> refresh() async {
    await fetchAllRegisterUsers();
  }

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
