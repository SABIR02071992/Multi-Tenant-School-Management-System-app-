import '../entities/classes_entity.dart';

abstract class ClassesRepository {
  Future<ClassEntity> createClasses(ClassEntity student);
  Future<List<ClassEntity>> getClasses();
}