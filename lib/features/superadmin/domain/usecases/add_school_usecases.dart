import '../entity/super_admin_entity.dart';
import '../repositories/add_school_repositories.dart';

class SCHOOLUseCase {
  final AddSchoolRepositories repository;

  SCHOOLUseCase(this.repository);

  Future<SchoolEntity> execute(String logo, String schoolName, String domain, String adminEmail, String planSetup) {
    return repository.addSchool(logo, schoolName, domain, adminEmail, planSetup);
  }
}