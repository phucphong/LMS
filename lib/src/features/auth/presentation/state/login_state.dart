
class LoginState {
  final bool isLoading;
  final String? error;
  final bool success;

  const LoginState({
    this.isLoading = false,
    this.error,
    this.success = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? error,
    bool? success,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success ?? this.success,
    );
  }
}
