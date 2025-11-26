/// ===========================================================================
/// LoginResult (Domain Entity)
/// ---------------------------
/// Đây là **kết quả đăng nhập** được tầng Data trả về → UseCase → Notifier → UI.
///
/// Đây là đối tượng **thuần Dart**, không phụ thuộc JSON, không chứa logic parse,
/// chỉ dùng để biểu diễn dữ liệu nghiệp vụ.
///
/// LÝ DO ĐẶT ENTITY RIÊNG:
///   ✓ Giúp Domain không phụ thuộc API JSON structure
///   ✓ Nếu API đổi field (ví dụ: "full_name" → "name"), chỉ sửa mapper ở tầng Data
///   ✓ UI/Domain không bị ảnh hưởng
///
/// Người tạo: **Phongnp – 0964 931 224**
/// ===========================================================================
class LoginResult {
  /// Token xác thực sau khi login thành công.
  /// UI hoặc tầng Data có thể lưu token vào local (Secure Storage).
  final String token;

  /// ID nhân viên (idnhanvien)
  /// → Dùng để map user đang đăng nhập đến thông tin hồ sơ nhân sự.
  final String idnhanvien;

  /// Họ tên đầy đủ của người dùng đăng nhập.
  /// → Sử dụng để hiển thị chào mừng trong giao diện Home.
  final String hoten;

  /// Constructor bất biến (immutable object)
  /// Tất cả field sử dụng `required` để đảm bảo entity luôn đủ dữ liệu.
  const LoginResult({
    required this.token,
    required this.idnhanvien,
    required this.hoten,
  });
}
