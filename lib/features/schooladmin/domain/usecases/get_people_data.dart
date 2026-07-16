import '../entities/people_entity.dart';
import '../repositories/people_repository.dart';

class GetPeopleData {
  final PeopleRepository repository;

  GetPeopleData(this.repository);

  Future<PeopleEntity> call() async {
    return await repository.getPeople();
  }
}