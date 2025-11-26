import '../../../usecases/usecase.dart';
import '../domain/entities/login_result.dart';
import '../domain/repositories/auth_repository.dart';

/// ===========================================================================
/// LoginParams
/// ------------
/// Đây là DTO (Data Transfer Object) dùng để truyền dữ liệu từ UI → UseCase.
/// Tách riêng object params giúp:
///   - Dễ mở rộng (sau thêm email, deviceId… vẫn không phá code cũ)
///   - Dễ test
/// ===========================================================================
class LoginParams {
  final String username;
  final String password;

  const LoginParams({
    required this.username,
    required this.password,
  });
}

/// ===========================================================================
/// LoginUseCase
/// -------------
/// Tầng DOMAIN (business logic thuần) theo Clean Architecture.
///
/// ✓ Không biết UI là gì
/// ✓ Không biết API là gì
/// ✓ Không biết JSON là gì
///
/// Chỉ biết gọi: **AuthRepository.login()**
///
/// FLOW:
///   LoginNotifier → LoginUseCase → AuthRepository → Data Source (API)
///
/// Tác giả: Phongnp – 0964 931 224
/// ===========================================================================
class LoginUseCase implements UseCase<LoginResult, LoginParams> {
  /// Repository được inject từ Riverpod (thông qua loginUseCaseProvider)
  /// Đây là nơi chứa:
  ///   - Xử lý API login
  ///   - Lưu token
  ///   - Map JSON → Domain model LoginResult
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// ------------------------------------------------------------------------
  /// call()
  /// -------
  /// Triển khai phương thức call từ interface UseCase
  ///
  /// Nhiệm vụ:
  ///   - Nhận LoginParams
  ///   - Gửi sang AuthRepository.login()
  ///   - Trả về LoginResult (domain entity)
  ///
  /// Không bắt lỗi tại đây, để tầng Presentation (LoginNotifier) xử lý.
  /// ------------------------------------------------------------------------
  @override
  Future<LoginResult> call(LoginParams params) {
    return repository.login(
      username: params.username,
      password: params.password,
    );
  }
}
