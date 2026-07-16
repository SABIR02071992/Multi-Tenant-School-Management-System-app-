import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/local_storage.dart';
import '../widgets/k_no_internet_dialog.dart';
import 'api_client.dart';
import 'internet_service.dart';

final dioClientProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = LocalStorageService();

  dio.options.baseUrl = ApiClient.baseUrl;
  dio.options.connectTimeout = const Duration(seconds: 15);
  dio.options.receiveTimeout = const Duration(seconds: 15);
  dio.options.headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  };

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {

        final connected = await InternetService.instance.hasInternet();
        if (!connected) {
          showNoInternetDialog();

          return handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
              error: "No Internet Connection",
            ),
          );
        }

        final String? token = storage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        log("\n========== ↗️ API REQUEST ==========");
        log("🔗 URL: ${options.baseUrl}${options.path}");
        log("📝 METHOD: ${options.method}");
        log("🔐 HEADERS: ${options.headers['Authorization'] != null ? 'Bearer Token Attached' : 'No Token'}");
        if (options.data != null) {
          log("📦 BODY: ${options.data is FormData ? 'FormData (Multipart)' : options.data}");
        }
        log("===================================\n");
        return handler.next(options);
      },

      onResponse: (response, handler) {
        log("\n========== 📥 API RESPONSE ==========");
        log("🔗 URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}");
        log("🟢 STATUS: ${response.statusCode} ${response.statusMessage}");
        log("📄 DATA: ${response.data}");
        log("====================================\n");
        return handler.next(response);
      },

      onError: (DioException e, handler) {
        log("\n========== 🚨 API ERROR ==========");
        log("🔗 URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}");
        log("🔴 STATUS: ${e.response?.statusCode}");
        log("💬 ERROR MESSAGE: ${e.message}");
        log("📄 ERROR DATA: ${e.response?.data}");
        log("==================================\n");

        if (e.response?.statusCode == 401) {
          log("⚠️ Token expired or invalid! User needs to re-login.");
        }

        return handler.next(e);
      },
    ),
  );
  return dio;
});
