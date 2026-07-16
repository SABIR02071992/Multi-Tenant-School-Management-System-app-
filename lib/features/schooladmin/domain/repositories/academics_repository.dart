import '../entities/academies_entity.dart';

abstract class AcademicsRepository {
  Future<AcademicsEntity> getAcademics();
}