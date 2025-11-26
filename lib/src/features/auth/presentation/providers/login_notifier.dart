import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/network/api_client.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../usecases/login_usecase.dart';
import '../state/login_state.dart';

// quản lý state

final loginNotifierProvider =
StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final apiClient = ApiClient();
  final remote = AuthRemoteDataSourceImpl(apiClient);
  final repo = AuthRepositoryImpl(remote);
  final useCase = LoginUseCase(repo);

  return LoginNotifier(useCase);
});

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this._loginUseCase) : super(const LoginState());

  final LoginUseCase _loginUseCase;

  Future<void> login(String username, String password) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null, success: false);

    try {
      final result =
      await _loginUseCase(LoginParams(username: username, password: password));

      // TODO: lưu token vào secure storage nếu cần
      // e.g. await _tokenStore.save(result.token);

      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: (e is Failure) ? e.message : e.toString(),
      );
    }
  }
}
