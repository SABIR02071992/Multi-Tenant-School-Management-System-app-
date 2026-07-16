import '../../domain/entities/classes_entity.dart';
import '../../domain/repositories/classes_repositories.dart';
import '../datasource/class_remote_datasource.dart';
import '../model/classes_model.dart';

class ClassesRepositoryImpl implements ClassesRepository {
  final ClassRemoteDatasource remoteDataSource;

  ClassesRepositoryImpl(this.remoteDataSource);

  @override
  Future<ClassEntity> createClasses(ClassEntity student) async {
    final model = ClassModel.fromEntity(student);

    return await remoteDataSource.createClasses(model);
  }


  @override
  Future<List<ClassEntity>> getClasses() async {
    return await remoteDataSource.getClasses();
  }
}