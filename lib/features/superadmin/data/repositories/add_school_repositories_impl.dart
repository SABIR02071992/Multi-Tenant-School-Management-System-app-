import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vidya_setu/features/superadmin/domain/entity/super_admin_entity.dart';
import 'package:vidya_setu/features/superadmin/domain/repositories/add_school_repositories.dart';

import '../../../../core/network/api_client.dart';
import '../models/school_model.dart';

class AddSchoolRepositoriesImpl implements AddSchoolRepositories {
  // 🎯 अब यहाँ कोई एरर नहीं आएगी, क्योंकि ApiClient() वापस पहले जैसा हो गया है
  final Dio _dio;
  AddSchoolRepositoriesImpl(this._dio);

  @override
  Future<SchoolEntity> addSchool(String logo, String schoolName, String domain, String adminEmail, String planSetup) async {

    try{
      final response = await _dio.post(
        ApiClient.onboardSchool,
        data: {
          'logo': logo,
          'schoolName': schoolName,
          'domain': domain,
          'adminEmail': adminEmail,
          'planSetup': planSetup,
        }
      );
      if(response.statusCode == 200){
        final data = response.data;
        return SchoolModel.fromJson(data['school']);

      }else{
        throw Exception("School Add Failed!");
      }
    } catch (e){
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
