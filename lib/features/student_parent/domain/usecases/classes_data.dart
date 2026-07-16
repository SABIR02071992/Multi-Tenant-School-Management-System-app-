import '../entities/classes_entity.dart';
import '../repositories/classes_repositories.dart';

class ClassesData {
  final ClassesRepository repository;
  ClassesData(this.repository);

  Future<ClassEntity> call(ClassEntity classes) async {
    return await repository.createClasses(classes);
  }

  // Get All Classes
  Future<List<ClassEntity>> getClasses() async {
    return await repository.getClasses();
  }

}