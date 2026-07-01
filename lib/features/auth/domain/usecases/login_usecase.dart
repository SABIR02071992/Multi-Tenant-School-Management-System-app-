// lib/features/auth/domain/usecases/login_usecase.dart
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> execute(String email, String password, String role) {
    return repository.login(email, password, role);
  }
}
