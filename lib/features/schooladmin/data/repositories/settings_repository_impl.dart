import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settinge_repository.dart';
import '../datasource/settings_remote_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  SettingsRepositoryImpl(this.remoteDataSource);
  @override
  Future<SettingsEntity> getSettings() async {
    return await remoteDataSource.getSettings();
  }
}