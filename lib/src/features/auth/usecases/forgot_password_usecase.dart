

import '../domain/repositories/auth_repository.dart';

class ForgotPasswordParams {
  final String phone;

  ForgotPasswordParams(this.phone);
}

class ForgotPasswordUseCase {
  final AuthRepository _repo;

  ForgotPasswordUseCase(this._repo);

  Future<void> call(ForgotPasswordParams params) {
    return _repo.forgotPassword(params.phone);
  }
}
