import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/local_storage.dart';
import 'api_client.dart';

final dioClientProvider = Provider<Dio>((ref) {
  final dio = Dio();

  // यहाँ अपनी लोकल स्टोरेज सर्विस का इंस्टेंस लें (ताकि टोकन रीड कर सकें)
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

      // 📥 जब सर्वर से Response वापस आएगा (लॉग प्रिंट होगा)
      onResponse: (response, handler) {
        log("\n========== 📥 API RESPONSE ==========");
        log("🔗 URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}");
        log("🟢 STATUS: ${response.statusCode} ${response.statusMessage}");
        log("📄 DATA: ${response.data}");
        log("====================================\n");
        return handler.next(response);
      },

      // ❌ अगर API में कोई Error आता है (जैसे 401 Unauthorized या 500)
      onError: (DioException e, handler) {
        log("\n========== 🚨 API ERROR ==========");
        log("🔗 URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}");
        log("🔴 STATUS: ${e.response?.statusCode}");
        log("💬 ERROR MESSAGE: ${e.message}");
        log("📄 ERROR DATA: ${e.response?.data}");
        log("==================================\n");

        // 💡 बोनस: अगर टोकन एक्सपायर हो जाता है (401 Error), तो यूज़र को लॉगआउट करने का लॉजिक यहाँ डाल सकते हैं
        if (e.response?.statusCode == 401) {
          log("⚠️ Token expired or invalid! User needs to re-login.");
        }

        return handler.next(e);
      },
    ),
  );

  return dio;
});
