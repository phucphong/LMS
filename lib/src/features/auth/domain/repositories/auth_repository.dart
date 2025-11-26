import '../entities/login_result.dart';
import '../entities/trial_register_request.dart';

/// ===========================================================================
/// AuthRepository (Domain Layer)
/// -----------------------------
/// Đây là **interface gốc** mô tả tất cả hành vi liên quan đến Authentication.
///
/// Nằm trong tầng **Domain**, nên:
///   - Không chứa code API
///   - Không chứa code JSON
///   - Không chứa UI
///   - Không phụ thuộc vào framework (HTTP client, Dio, v.v.)
///
/// Mục tiêu:
///   ✓ Tách biệt toàn bộ logic nghiệp vụ (UseCase) khỏi tầng triển khai API
///   ✓ Giúp test dễ dàng (mock repository)
///   ✓ Dễ mở rộng khi đổi API, đổi server, đổi thư viện network
///
/// TẬP HỢP NGHIỆP VỤ HIỆN CÓ:
/// 1) login(username, password)
/// 2) registerTrial(TrialRegisterRequest)
///
/// Người tạo: **Phongnp – 0964 931 224**
/// ===========================================================================
abstract class AuthRepository {

  /// ------------------------------------------------------------------------
  /// login()
  /// -------
  /// - Nhận username + password từ LoginUseCase
  /// - Trả về LoginResult (Domain Entity)
  ///
  /// Tầng Data sẽ CURRENTLY làm:
  ///   - Gọi API /auth/login
  ///   - Parse JSON → LoginResult
  ///   - Lưu token nếu cần
  ///   - Bắn exception Failure nếu lỗi server hoặc lỗi logic
  ///
  /// Domain Layer chỉ định nghĩa hành vi — KHÔNG triển khai.
  /// ------------------------------------------------------------------------
  Future<LoginResult> login({
    required String username,
    required String password,
  });

  /// ------------------------------------------------------------------------
  /// registerTrial()
  /// ----------------
  /// - Nhận một TrialRegisterRequest (Domain Entity)
  ///     bao gồm: fullName, phone, grade, isParent
  ///
  /// Tầng Data sẽ:
  ///   - Chuyển request → JSON
  ///   - Gọi API POST /auth/register-trial
  ///   - Bắt lỗi, chuyển thành Failure nếu cần
  ///
  /// Trả về Future<void> vì API không trả object
  /// (trường hợp có trả object → sẽ đổi thành Domain Entity)
  /// ------------------------------------------------------------------------
  Future<void> registerTrial(TrialRegisterRequest request);
  //  FORGOT PASSWORD
  Future<void> forgotPassword(String phone);

}
