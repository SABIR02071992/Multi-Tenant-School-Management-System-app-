import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_client_provider.dart';
import '../model/dashboard_model.dart';


final dashboardRemoteDataSourceProvider =
Provider<DashboardRemoteDataSource>((ref) {
  final dio = ref.watch(dioClientProvider);
  return DashboardRemoteDataSource(dio);
});

class DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSource(this.dio);

  Future<DashboardModel> getDashboard() async {
    try {
      final response = await dio.get(ApiClient.dashboardHome);

      return DashboardModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            e.message ??
            "Unable to load dashboard",
      );
    }
  }
}