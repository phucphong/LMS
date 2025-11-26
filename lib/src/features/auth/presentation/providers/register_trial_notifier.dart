import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/failure.dart';
import '../../usecases/register_trial_usecase.dart';
import '../../auth_providers.dart';
import '../state/register_trial_state.dart';

class RegisterTrialNotifier extends StateNotifier<RegisterTrialState> {
  final RegisterTrialUseCase _useCase;

  RegisterTrialNotifier(this._useCase) : super(const RegisterTrialState());

  Future<void> register({
    required bool isParent,
    required String fullName,
    required String phone,
    required String grade,
  }) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      success: false,
      error: null,
    );

    try {
      await _useCase(
        RegisterTrialParams(
          isParent: isParent,
          fullName: fullName,
          phone: phone,
          grade: grade,
        ),
      );

      state = state.copyWith(
        isLoading: false,
        success: true,
        error: null,
      );
    } catch (e) {
      final msg = e is Failure ? e.message : e.toString();
      state = state.copyWith(
        isLoading: false,
        success: false,
        error: msg,
      );
    }
  }

  void reset() {
    state = const RegisterTrialState();
  }
}

/// Provider cho Notifier (UI dùng cái này)
final registerTrialNotifierProvider =
StateNotifierProvider<RegisterTrialNotifier, RegisterTrialState>((ref) {
  final useCase = ref.read(registerTrialUseCaseProvider);
  return RegisterTrialNotifier(useCase);
});
