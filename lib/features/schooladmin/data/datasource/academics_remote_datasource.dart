import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_client_provider.dart';
import '../model/academics_model.dart';

final academicsRemoteDataSourceProvider =
Provider<AcademicsRemoteDataSource>((ref) {
  final dio = ref.watch(dioClientProvider);
  return AcademicsRemoteDataSource(dio);
});

class AcademicsRemoteDataSource {
  final Dio dio;

  AcademicsRemoteDataSource(this.dio);
  Future<AcademicsModel> getAcademics() async {
    try {
      final response = await dio.get(ApiClient.dashboardAcademics);

      log("#Response${response.data}");

      final model = AcademicsModel.fromJson(response.data);

      return model;
    } catch (e, s) {
      log("#Error$e");
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
}
