import 'package:vidya_setu/features/student_parent/domain/entities/student_entity.dart';
import 'package:vidya_setu/features/student_parent/domain/repositories/create_student_repository.dart';


class CreateStudentData {
  final CreateStudentRepository repository;

  CreateStudentData(this.repository);

  Future<StudentEntity> call(StudentEntity student) async {
    return await repository.createStudent(student);
  }
}