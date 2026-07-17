import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/network/api_client.dart';
import '../model/student_model.dart';

class GetStudentRemoteDataSource {
  final Dio _dio;

  GetStudentRemoteDataSource(this._dio);

  Future<List<StudentModel>> getStudents() async {
    try {
      final response = await _dio.get(ApiClient.getStudents);

      log("#Response ${response.data}");

      final List<dynamic> data = response.data["students"] ?? [];

      return data
          .map((e) => StudentModel.fromJson(e))
          .toList();
    } catch (e, s) {
      log("#Error $e");
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
}