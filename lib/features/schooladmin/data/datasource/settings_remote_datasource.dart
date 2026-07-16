import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_client_provider.dart';
import '../model/settings_model.dart';

final settingsRemoteDataSourceProvider =
Provider<SettingsRemoteDataSource>((ref) {
  final dio = ref.watch(dioClientProvider);
  return SettingsRemoteDataSource(dio);
});

class SettingsRemoteDataSource {
  final Dio dio;

  SettingsRemoteDataSource(this.dio);
  Future<SettingsModel> getSettings() async {
    try {
      final response = await dio.get(ApiClient.dashboardSettings);

      log("#Error${response.data}");

      final model = SettingsModel.fromJson(response.data);

      return model;
    } catch (e, s) {
      debugPrint("Parsing Error: $e");
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
}