import 'package:vidya_setu/features/schooladmin/domain/entities/people_entity.dart';

abstract class PeopleRepository {
  Future<PeopleEntity> getPeople();
}
