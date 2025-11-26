
import '../entities/login_result.dart';

abstract class AuthRepository {
  Future<LoginResult> login({
    required String username,
    required String password,
  });
}
