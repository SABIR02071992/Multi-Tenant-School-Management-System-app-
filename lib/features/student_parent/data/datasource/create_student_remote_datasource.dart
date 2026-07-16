
import 'package:dio/dio.dart';
import 'package:vidya_setu/features/student_parent/data/model/student_model.dart';
import '../../../../core/network/api_client.dart';


class CreateStudentRemoteDataSource {
  final Dio dio;
  CreateStudentRemoteDataSource(this.dio);

 /* Future<StudentModel> createStudent(StudentModel student) async {
    try {
      final response = await dio.post(
        ApiClient.createStudent,
        data: student.toJson(),
      );

      log("#Response ${response.data}");

      return StudentModel.fromJson(response.data["data"]);
    } catch (e, s) {
      log("#Error $e");
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }*/
  Future<StudentModel> createStudent(StudentModel student) async {
    try {
      final formData = FormData.fromMap({
        "admission_no": student.admissionNo,
        "first_name": student.firstName,
        "last_name": student.lastName,
        "gender": student.gender,
        "dob": student.dob,
        "mobile": student.mobile,
        "email": student.email,
        "father_name": student.fatherName,
        "mother_name": student.motherName,
        "class_name": student.className,
        "section": student.section,
        "address": student.address,

        if (student.photo != null && student.photo!.isNotEmpty)
          "photo": await MultipartFile.fromFile(
            student.photo!,
            filename: student.photo!.split('/').last,
          ),
      });

      final response = await dio.post(
        ApiClient.createStudent,
        data: formData,
      );

      return StudentModel.fromJson(response.data["data"]);
    } catch (e) {
      rethrow;
    }
  }
}