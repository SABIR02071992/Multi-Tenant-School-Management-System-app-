import '../../domain/entities/academies_entity.dart';
import '../../domain/repositories/academics_repository.dart';
import '../datasource/academics_remote_datasource.dart';

class AcademicsRepositoryImpl implements AcademicsRepository{
  final AcademicsRemoteDataSource remoteDataSource;
  AcademicsRepositoryImpl(this.remoteDataSource);
  @override
  Future<AcademicsEntity> getAcademics() async {
    return await remoteDataSource.getAcademics();
  }
}
