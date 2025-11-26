import '../domain/entities/trial_register_request.dart';
import '../domain/repositories/auth_repository.dart';

/// ===========================================================================
/// RegisterTrialParams
/// -------------------
/// DTO chứa dữ liệu đầu vào cho luồng Đăng ký học thử.
///
/// LÝ DO TÁCH PARAM OBJECT RIÊNG:
///   ✓ Gọn gàng hơn khi truyền dữ liệu
///   ✓ Sau này thêm trường mới (email, age, classType…) không làm hỏng code cũ
///   ✓ Tách biệt nhiệm vụ giữa tầng Presentation và Domain
///
/// Đại diện cho input UI gửi xuống Domain.
/// ===========================================================================
class RegisterTrialParams {
  final String hoten;
  final String dienthoai;
  final String email;
  final String username;
  final String password;

  const RegisterTrialParams({
    required this.hoten,
    required this.dienthoai,
    required this.email,
    required this.username,
    required this.password,
  });

  /// ------------------------------------------------------------------------
  /// toRequest()
  /// -----------
  /// Chuyển RegisterTrialParams → TrialRegisterRequest (Domain Entity).
  ///
  /// LÝ DO CẦN toRequest():
  ///   - Params = dữ liệu UI gửi vào → mang tính tạm thời
  ///   - Request Model (TrialRegisterRequest) = dữ liệu chuẩn của tầng Domain
  ///   - Tách biệt để giữ thiết kế Clean Architecture sạch sẽ & rõ ràng
  /// ------------------------------------------------------------------------
  TrialRegisterRequest toRequest() => TrialRegisterRequest(
        hoten: hoten,
        dienthoai: dienthoai,
        email: email,
        username: username,
        password: password,
      );
}

/// ===========================================================================
/// RegisterTrialUseCase
/// ---------------------
/// TẦNG DOMAIN – Chứa nghiệp vụ Đăng ký học thử.
///
/// ❗ Không chứa logic UI
/// ❗ Không gọi API trực tiếp
/// ❗ Không parse JSON
///
/// Nhiệm vụ duy nhất:
///   - Nhận RegisterTrialParams
///   - Chuyển sang Request Model
///   - Gọi Repository để xử lý đăng ký học thử
///
/// FLOW:
/// UI → RegisterTrialNotifier → RegisterTrialUseCase → AuthRepository → API
///
/// Người tạo: **Phongnp – 0964 931 224**
/// ===========================================================================
class RegisterTrialUseCase {
  /// Repository thực hiện hành động đăng ký (tầng Data triển khai)
  final AuthRepository _repository;

  RegisterTrialUseCase(this._repository);

  /// ------------------------------------------------------------------------
  /// call()
  /// ------
  /// UseCase theo chuẩn Clean Architecture thường sử dụng kiểu call() này
  ///
  /// NHIỆM VỤ:
  ///   - Chuyển params → Domain Request Model
  ///   - Gọi repository.registerTrial(request)
  ///   - Trả về Future<void> (không cần kết quả gì)
  ///
  /// Việc bắt lỗi sẽ được thực hiện ở tầng Notifier.
  /// ------------------------------------------------------------------------
  Future<void> call(RegisterTrialParams params) {
    return _repository.registerTrial(
      params.toRequest(), // convert params → TrialRegisterRequest
    );
  }
}
