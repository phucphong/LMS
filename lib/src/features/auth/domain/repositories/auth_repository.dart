
import '../entities/login_result.dart';
import '../entities/trial_register_request.dart';

abstract class AuthRepository {
  Future<LoginResult> login({
    required String username,
    required String password,
  });

  Future<void> registerTrial(TrialRegisterRequest request);
}
