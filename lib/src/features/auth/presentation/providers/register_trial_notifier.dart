import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/failure.dart';
import '../../usecases/register_trial_usecase.dart';
import '../../auth_providers.dart';
import '../state/register_trial_state.dart';

/// ===========================================================================
/// RegisterTrialNotifier
/// ---------------------
/// QUẢN LÝ LUỒNG ĐĂNG KÝ HỌC THỬ (REGISTER TRIAL)
///
/// - Là tầng PRESENTATION trong Clean Architecture
/// - Nhiệm vụ:
///     + Nhận input từ UI (họ tên, email, lớp, là phụ huynh hay học sinh)
///     + Gọi RegisterTrialUseCase (tầng domain)
///     + Cập nhật RegisterTrialState để UI rebuild theo trạng thái mới
///
/// TRẠNG THÁI:
/// - isLoading  → UI hiển thị progress
/// - success    → UI điều hướng sang HomePage
/// - error      → UI hiển thị toast lỗi
///
/// Người tạo: **Phongnp – 0964 931 224**
/// ===========================================================================
class RegisterTrialNotifier extends StateNotifier<RegisterTrialState> {
  /// UseCase chứa logic nghiệp vụ đăng ký học thử
  final RegisterTrialUseCase _useCase;

  /// Khởi tạo state mặc định = RegisterTrialState()
  RegisterTrialNotifier(this._useCase) : super(const RegisterTrialState());

  /// ------------------------------------------------------------------------
  /// HÀM register()
  /// ---------------
  /// UI gọi hàm này khi người dùng nhấn nút "BẮT ĐẦU HỌC THỬ"
  ///
  /// THAM SỐ:
  /// - hoten  : true = phụ huynh, false = học sinh
  /// - dienthoai  : họ và tên
  /// - email     : số điện thoại
  /// - username     : lớp (Lớp 1 → Lớp 12)
  ///
  /// FLOW:
  ///   1. Kiểm tra không cho ấn liên tục nếu đang loading
  ///   2. Set state.loading = true
  ///   3. Gọi UseCase
  ///   4. Thành công → state.success = true
  ///   5. Thất bại → state.error = message (UI show toast)
  /// ------------------------------------------------------------------------
  Future<void> register({
    required String hoten,
    required String dienthoai,
    required String email,
    required String username,
    required String password,
  }) async {
    // Nếu đang loading thì bỏ qua (tránh bấm nút liên tục)
    if (state.isLoading) return;

    // Bắt đầu đăng ký → reset error & success
    state = state.copyWith(
      isLoading: true,
      success: false,
      error: null,
    );

    try {
      // Gọi tầng Domain UseCase
      await _useCase(
        RegisterTrialParams(
          hoten: hoten,
          dienthoai: dienthoai,
          email: email,
          username: username,
          password: password,
        ),
      );

      // Thành công → success = true → UI điều hướng HomePage
      state = state.copyWith(
        isLoading: false,
        success: true,
        error: null,
      );
    } catch (e) {
      // Lỗi domain (Failure) hoặc lỗi hệ thống
      final msg = e is Failure ? e.message : e.toString();

      // Cập nhật lỗi → UI hiển thị toast lỗi
      state = state.copyWith(
        isLoading: false,
        success: false,
        error: msg,
      );
    }
  }

  /// ------------------------------------------------------------------------
  /// reset()
  /// -------
  /// Reset state về trạng thái ban đầu
  ///
  /// Có thể dùng trong các trường hợp:
  /// - Rời khỏi màn đăng ký
  /// - Nhấn "Làm mới form"
  /// - Chuẩn bị đăng ký lại lần nữa
  /// ------------------------------------------------------------------------
  void reset() {
    state = const RegisterTrialState();
  }
}

/// ===========================================================================
/// Provider cho UI sử dụng
///
/// UI sẽ dùng:
///   - ref.watch(registerTrialNotifierProvider) → lấy state
///   - ref.read(registerTrialNotifierProvider.notifier) → gọi register()
///
/// Provider tự đọc UseCase từ registerTrialUseCaseProvider và inject vào notifier
/// ===========================================================================
final registerTrialNotifierProvider =
StateNotifierProvider<RegisterTrialNotifier, RegisterTrialState>((ref) {
  final useCase = ref.read(registerTrialUseCaseProvider);
  return RegisterTrialNotifier(useCase);
});
