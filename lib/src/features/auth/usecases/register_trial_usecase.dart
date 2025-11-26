
import '../domain/entities/trial_register_request.dart';
import '../domain/repositories/auth_repository.dart';

class RegisterTrialParams {
  final bool isParent;
  final String fullName;
  final String phone;
  final String grade;

  const RegisterTrialParams({
    required this.isParent,
    required this.fullName,
    required this.phone,
    required this.grade,
  });

  TrialRegisterRequest toRequest() => TrialRegisterRequest(
    isParent: isParent,
    fullName: fullName,
    phone: phone,
    grade: grade,
  );
}

class RegisterTrialUseCase {
  final AuthRepository _repository;

  RegisterTrialUseCase(this._repository);

  Future<void> call(RegisterTrialParams params) {
    return _repository.registerTrial(params.toRequest());
  }
}
