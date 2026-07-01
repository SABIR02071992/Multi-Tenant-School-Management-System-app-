import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_client_provider.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  AuthRepositoryImpl(this._dio);

  @override
  Future<UserEntity> login(String email, String password, String role) async {
    try {
      final response = await _dio.post(
        ApiClient.login,
        data: {
          'email': email,
          'password': password,
          'role': role,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return UserModel.fromJson(data['user']);
      } else {
        throw Exception("Login failed!");
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthRepositoryImpl(dio);
});
