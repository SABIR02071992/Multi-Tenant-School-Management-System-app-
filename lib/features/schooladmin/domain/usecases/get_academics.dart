import 'package:vidya_setu/features/schooladmin/domain/repositories/academics_repository.dart';

import '../entities/academies_entity.dart';

class GetAcademicsData {
  final AcademicsRepository repository;
  GetAcademicsData(this.repository);
  Future<AcademicsEntity> call() async {
    return await repository.getAcademics();
  }
}