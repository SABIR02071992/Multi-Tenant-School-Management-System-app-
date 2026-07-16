import 'package:vidya_setu/features/student_parent/domain/entities/student_entity.dart';

abstract class CreateStudentRepository {
  Future<StudentEntity> createStudent(StudentEntity student);
}