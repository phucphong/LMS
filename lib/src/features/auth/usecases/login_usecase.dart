

import '../domain/entities/login_result.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/usecase.dart';



class LoginParams {
  final String username;
  final String password;

  const LoginParams({
    required this.username,
    required this.password,
  });
}

class LoginUseCase implements UseCase<LoginResult, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<LoginResult> call(LoginParams params) {
    return repository.login(
      username: params.username,
      password: params.password,
    );
  }
}
