
import '../entity/super_admin_entity.dart';

abstract class AddSchoolRepositories {
  Future<SchoolEntity> addSchool(String logo, String schoolName, String domain, String adminEmail, String planSetup);
}