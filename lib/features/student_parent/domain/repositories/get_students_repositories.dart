import '../entities/student_entity.dart';

abstract class GetStudentRepository {
  Future<List<StudentEntity>> getStudents();
}