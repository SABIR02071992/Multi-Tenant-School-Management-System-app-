import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vidya_setu/features/student_parent/data/model/classes_model.dart';

import '../../../../core/network/api_client.dart';

class ClassRemoteDatasource {
  final Dio dio;
  ClassRemoteDatasource(this.dio);

  Future<ClassModel> createClasses(ClassModel classes) async {
    try {
      final response = await dio.post(
        ApiClient.createClasses,
        data: classes.toJson(),
      );

      log("#Response ${response.data}");

      return ClassModel.fromJson(response.data["data"]);
    } catch (e, s) {
      log("#Error $e");
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  Future<List<ClassModel>> getClasses() async {
    try {
      final response = await dio.get(
        ApiClient.getClasses,
      );

      log("#Response ${response.data}");

      final List<dynamic> data = response.data["data"];

      return data
          .map((e) => ClassModel.fromJson(e))
          .toList();
    } catch (e, s) {
      log("#Error $e");
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
}