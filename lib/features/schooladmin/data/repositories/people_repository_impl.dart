import 'package:vidya_setu/features/schooladmin/data/datasource/people_remote_datasource.dart';

import '../../domain/entities/people_entity.dart';
import '../../domain/repositories/people_repository.dart';

class PeopleRepositoryImpl implements PeopleRepository{
  final PeopleRemoteDataSource remoteDataSource;
  PeopleRepositoryImpl(this.remoteDataSource);
  @override
  Future<PeopleEntity> getPeople() async {
    return await remoteDataSource.getPeople();
  }
}
