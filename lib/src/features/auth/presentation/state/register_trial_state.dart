class RegisterTrialState {
  final bool isLoading;
  final bool success;
  final String? error;

  const RegisterTrialState({
    this.isLoading = false,
    this.success = false,
    this.error,
  });

  RegisterTrialState copyWith({
    bool? isLoading,
    bool? success,
    String? error,
  }) {
    return RegisterTrialState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      error: error,
    );
  }
}
