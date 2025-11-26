import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/failure.dart';

import '../../usecases/login_usecase.dart';
import '../../auth_providers.dart';
import '../state/login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this._loginUseCase) : super(const LoginState());

  final LoginUseCase _loginUseCase;

  Future<void> login(String username, String password) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null, success: false);

    try {
      await _loginUseCase(
        LoginParams(username: username, password: password),
      );

      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: (e is Failure) ? e.message : e.toString(),
      );
    }
  }
}

// Provider cho Notifier (UI dùng cái này)
final loginNotifierProvider =
StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final useCase = ref.read(loginUseCaseProvider);
  return LoginNotifier(useCase);
});
