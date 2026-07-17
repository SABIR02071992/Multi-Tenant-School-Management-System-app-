import '../../domain/entities/student_entity.dart';
import '../../domain/repositories/get_students_repositories.dart';
import '../datasource/get_student_remote_datasource.dart';

class GetStudentRepositoryImpl implements GetStudentRepository {
  final GetStudentRemoteDataSource remoteDataSource;
  GetStudentRepositoryImpl(this.remoteDataSource);
  
  @override
  Future<List<StudentEntity>> getStudents() async {
    return await remoteDataSource.getStudents();
  }

}