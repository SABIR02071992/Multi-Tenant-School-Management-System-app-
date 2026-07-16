import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/features/schooladmin/data/model/people_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_client_provider.dart';

final peopleRemoteDataSourceProvider =
Provider<PeopleRemoteDataSource>((ref) {
  final dio = ref.watch(dioClientProvider);
  return PeopleRemoteDataSource(dio);
});

class PeopleRemoteDataSource {
  final Dio dio;

  PeopleRemoteDataSource(this.dio);
  Future<PeopleModel> getPeople() async {
    try {
      final response = await dio.get(ApiClient.dashboardPeople);

      log("#Error${response.data}");

      final model = PeopleModel.fromJson(response.data);

      return model;
    } catch (e, s) {
      debugPrint("Parsing Error: $e");
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
}
