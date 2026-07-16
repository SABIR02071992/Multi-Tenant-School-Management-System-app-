import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_client_provider.dart';
import '../../../../core/utils/local_storage.dart';
import '../../domain/entities/user_entity.dart';

class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final Dio _dio;
  final storage = LocalStorageService();

  AuthNotifier(this._dio) : super(const AsyncValue.data(null));

  Future<void> loginUser({
    required String email,
    required String password,
    String? schoolDomain,
  }) async {
    state = const AsyncValue.loading();
    try {
      String loginUrl = ApiClient.login;
      Options requestOptions = Options();

      // Dynamic Request Payload Map Generation
      Map<String, dynamic> requestBody = {
        'email': email.trim(),
        'password': password,
      };

      // Decision Structural Routing logic
      if (schoolDomain == null || schoolDomain.trim().isEmpty) {
        // 1. Super Admin Context
        loginUrl = ApiClient.userAdminLogin;
      } else {
        // 2. Tenant Context
        String cleanDomain = schoolDomain.toLowerCase().trim();
        requestBody['school_domain'] = cleanDomain;

        requestOptions = Options(
          headers: {
            'X-School-Domain': cleanDomain,
          },
        );
      }

      // Execute Network Call
      final response = await _dio.post(
        loginUrl,
        data: requestBody,
        options: requestOptions,
      );

      if (response.statusCode == 200 && response.data is Map) {
        final Map<String, dynamic> responseData = response.data;
        final userData = responseData['user'];
        final String? token = responseData['token'];

        if (token != null && userData != null) {
          log("#Saved_Token Saved successfully: $token");

          // 🟢 1. सभी स्टोरेज ऑपरेशन्स के आगे await सुनिश्चित किया
           storage.saveToken(token);


          final String serverRole = (userData['role'] ?? 'NA').toString();
           storage.saveRole(serverRole);
           storage.saveUser(userData['name'] ?? 'NA');
          log("#Saved_Role: ${storage.getRole()}");



          if (schoolDomain != null && schoolDomain.trim().isNotEmpty) {
             storage.saveDomain(schoolDomain.toLowerCase().trim()); // 🟢 2. खाली ब्लॉक को भरा
          }
           storage.setLoginStatus(true);

          // 🟢 3. सुरक्षित रूप से यूज़र एंटिटी मैप करना
          final user = UserEntity(
            id: (userData['id'] ?? '0').toString(),
            name: (userData['name'] ?? 'School Admin Context').toString(),
            email: (userData['email'] ?? email).toString(),
            role: serverRole,
            schoolId: userData['school_id'] != null ? userData['school_id'].toString() : '0',
          );

          state = AsyncValue.data(user);
          return;
        }
      }
      state = AsyncValue.error("सर्वर से गलत डेटा प्राप्त हुआ!", StackTrace.current);
    } on DioException catch (e) {
      String errorMsg = "लॉगिन असफल रहा!";
      if (e.response != null && e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map) {
          errorMsg = data['error'] ?? errorMsg;
        } else if (data is String) {
          errorMsg = data;
        }
      } else {
        errorMsg = e.message ?? errorMsg;
      }
      state = AsyncValue.error(errorMsg, StackTrace.current);
    } catch (e) {
      // यहाँ पर एक्सेप्शन लॉग करके देखें कि असल में कौन सा वेरिएबल नल (Null) हो रहा है
      log("Parsing Exception Error: ${e.toString()}");
      state = AsyncValue.error("डाटा पार्सिंग एरर: ${e.toString()}", StackTrace.current);
    }
  }
}
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthNotifier(dio);
});
