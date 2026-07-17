import 'package:vidya_setu/features/student_parent/domain/entities/student_entity.dart';
import 'package:vidya_setu/features/student_parent/domain/repositories/get_students_repositories.dart';

class GetStudentData {
  final GetStudentRepository repository;
  GetStudentData(this.repository);

  // Get All Students
  Future<List<StudentEntity>> getStudent() async {
    return await repository.getStudents();
  }

}