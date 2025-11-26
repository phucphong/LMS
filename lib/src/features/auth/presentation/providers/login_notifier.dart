import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/failure.dart';

import '../../usecases/login_usecase.dart';
import '../../auth_providers.dart';
import '../state/login_state.dart';

/// ===========================================================================
/// LoginNotifier – Quản lý logic ĐĂNG NHẬP theo Clean Architecture + Riverpod
/// Người tạo: Phongnp – 0964 931 224
///
///  MỤC ĐÍCH:
///  - Điều khiển toàn bộ luồng xử lý đăng nhập
///  - Gọi LoginUseCase (tầng domain)
///  - Cập nhật LoginState để UI tự động rebuild
///
///  FLOW ĐĂNG NHẬP:
///  UI (LoginPage) → LoginNotifier.login() → LoginUseCase → Repository API
///        ↓
///      Success → cập nhật state.success = true
///      Error   → state.error chứa message → UI show toast
///
///  LoginNotifier không chứa logic UI, không decode JSON.
///  Chỉ quản lý state cho UI.
/// ===========================================================================
class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this._loginUseCase) : super(const LoginState());

  /// LoginUseCase (tầng domain)
  /// Bị inject từ Riverpod thông qua provider loginUseCaseProvider
  final LoginUseCase _loginUseCase;

  /// ------------------------------------------------------------------------
  /// HÀM login()
  ///
  /// Được UI gọi:
  ///   ref.read(loginNotifierProvider.notifier).login(username, password)
  ///
  /// Nhiệm vụ:
  ///   - Set trạng thái loading
  ///   - Gọi LoginUseCase(username, password)
  ///   - Bắt lỗi Failure hoặc lỗi hệ thống
  ///   - Cập nhật state theo kết quả (success/error)
  /// ------------------------------------------------------------------------
  Future<void> login(String username, String password) async {
    // Nếu đang loading thì bỏ qua (tránh double click liên tục)
    if (state.isLoading) return;

    // Bắt đầu loading → reset lỗi cũ & success cũ
    state = state.copyWith(isLoading: true, error: null, success: false);

    try {
      // Gọi UseCase ở tầng domain
      await _loginUseCase(
        LoginParams(username: username, password: password),
      );

      // Thành công → success = TRUE (UI sẽ chuyển sang HomePage)
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      // Lỗi từ UseCase → Failure(message)
      // Hoặc lỗi khác → e.toString()
      state = state.copyWith(
        isLoading: false,
        error: (e is Failure) ? e.message : e.toString(),
      );
    }
  }
}

/// ===========================================================================
/// PROVIDER: loginNotifierProvider
///
/// Đây là provider chính UI sẽ sử dụng:
///   - ref.watch(loginNotifierProvider)     → lấy state để hiển thị
///   - ref.read(loginNotifierProvider.notifier) → gọi login()
///
/// Provider sẽ tự động inject LoginUseCase từ loginUseCaseProvider
/// ===========================================================================

final loginNotifierProvider =
StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  // Lấy LoginUseCase từ provider khác
  final useCase = ref.read(loginUseCaseProvider);

  // Inject vào Notifier
  return LoginNotifier(useCase);
});
