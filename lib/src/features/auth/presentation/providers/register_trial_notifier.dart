import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/failure.dart';
import '../../usecases/register_trial_usecase.dart';
import '../../auth_providers.dart';
import '../state/register_trial_state.dart';

/// ===========================================================================
/// RegisterTrialNotifier
/// ---------------------
/// QUẢN LÝ LUỒNG ĐĂNG KÝ TÀI KHOẢN
///
/// - Là tầng PRESENTATION trong Clean Architecture
/// - Nhiệm vụ:
///     + Nhận input từ UI (họ tên, điện thoại, email, username, password)
///     + Gọi RegisterTrialUseCase (tầng domain)
///     + Cập nhật RegisterTrialState để UI rebuild theo trạng thái mới
///
/// TRẠNG THÁI:
/// - isLoading  → UI hiển thị progress
/// - success    → UI điều hướng sang HomePage
/// - error      → UI hiển thị toast lỗi
/// ===========================================================================
class RegisterTrialNotifier extends StateNotifier<RegisterTrialState> {
  /// UseCase chứa logic nghiệp vụ đăng ký
  final RegisterTrialUseCase _useCase;

  RegisterTrialNotifier(this._useCase) : super(const RegisterTrialState());

  /// ------------------------------------------------------------------------
  /// HÀM register()
  /// ---------------
  /// UI gọi hàm này khi người dùng nhấn nút "Đăng ký"
  ///
  /// THAM SỐ:
  /// - hoten      : Họ và tên
  /// - dienthoai  : Số điện thoại
  /// - email      : Email
  /// - username   : Tên đăng nhập / số định danh
  /// - password   : Mật khẩu
  /// ------------------------------------------------------------------------
  Future<void> register({
    required String hoten,
    required String dienthoai,
    required String email,
    required String username,
    required String password,
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
          hoten: hoten,
          dienthoai: dienthoai,
          email: email,
          username: username,
          password: password,
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

/// Provider cho UI sử dụng
final registerTrialNotifierProvider =
StateNotifierProvider<RegisterTrialNotifier, RegisterTrialState>((ref) {
  final useCase = ref.read(registerTrialUseCaseProvider);
  return RegisterTrialNotifier(useCase);
});
