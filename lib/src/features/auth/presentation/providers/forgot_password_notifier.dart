import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/failure.dart';

import '../../auth_providers.dart';
import '../../usecases/forgot_password_usecase.dart';
import '../state/forgot_password_state.dart';


class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  final ForgotPasswordUseCase _useCase;

  ForgotPasswordNotifier(this._useCase)
      : super(const ForgotPasswordState());

  Future<void> sendCode(String phone) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, success: false, error: null);

    try {
      await _useCase(ForgotPasswordParams(phone));
      state = state.copyWith(isLoading: false, success: true, error: null);
    } catch (e) {
      final msg = e is Failure ? e.message : e.toString();
      state = state.copyWith(isLoading: false, success: false, error: msg);
    }
  }

  void reset() {
    state = const ForgotPasswordState();
  }
}

/// Provider cho UseCase
final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return ForgotPasswordUseCase(repo);
});

/// Provider cho Notifier
final forgotPasswordNotifierProvider =
StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>((ref) {
  final useCase = ref.read(forgotPasswordUseCaseProvider);
  return ForgotPasswordNotifier(useCase);
});
