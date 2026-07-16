import '../entities/settings_entity.dart';
import '../repositories/settinge_repository.dart';

class GetSettingsData {
  final SettingsRepository repository;

  GetSettingsData(this.repository);

  Future<SettingsEntity> call() async {
    return await repository.getSettings();
  }

}