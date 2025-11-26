
import '../../domain/entities/login_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.remoteDataSource);

  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<LoginResult> login({
    required String username,
    required String password,
  }) {
    final request = LoginRequest(username: username, password: password);
    return remoteDataSource.login(request);
  }
}
