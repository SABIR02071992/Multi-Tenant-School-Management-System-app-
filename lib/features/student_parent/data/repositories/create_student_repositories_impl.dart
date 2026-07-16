import '../../domain/entities/student_entity.dart';
import '../../domain/repositories/create_student_repository.dart';
import '../datasource/create_student_remote_datasource.dart';
import '../model/student_model.dart';


class CreateStudentRepositoryImpl implements CreateStudentRepository {
  final CreateStudentRemoteDataSource remoteDataSource;

  CreateStudentRepositoryImpl(this.remoteDataSource);

  @override
  Future<StudentEntity> createStudent(StudentEntity student) async {
    final model = StudentModel.fromEntity(student);

    return await remoteDataSource.createStudent(model);
  }
}