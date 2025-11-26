import 'package:dio/dio.dart';

import '../../../../../core/network/api_client.dart';
import '../../domain/entities/trial_register_request.dart';
import '../models/login_request.dart';
import '../models/login_result_model.dart';

/// ===========================================================================
/// AuthRemoteDataSource (Remote Layer Interface)
/// ---------------------------------------------
/// Đây là interface mô tả ***các phương thức gọi API thật***.
///
/// Tầng này nằm trong ***Data Layer*** và NẰM DƯỚI Repository.
///
/// NHIỆM VỤ:
///   - Gọi API bằng Dio
///   - Gửi request dạng JSON
///   - Nhận phản hồi từ server
///   - Trả về Model (model data layer, không phải domain entity)
///
/// LƯU Ý:
///   - KHÔNG chứa logic nghiệp vụ
///   - KHÔNG chứa logic UI
///   - KHÔNG dùng domain entity ở đây
/// ===========================================================================
abstract class AuthRemoteDataSource {
  /// API Login
  Future<LoginResultModel> login(LoginRequest request);

  /// API Đăng ký học thử
  /// Server trả về List<dynamic> (theo API hiện tại)
  Future<List<dynamic>> registerTrial(TrialRegisterRequest request);

  Future<void> forgotPassword(String phone);
}

/// ===========================================================================
/// AuthRemoteDataSourceImpl
/// -------------------------
/// IMPLEMENT thực sự gọi API bằng Dio.
/// Tầng này xử lý:
///   ✓ endpoint URL
///   ✓ gửi JSON
///   ✓ nhận JSON
///   ✓ parse về Model (LoginResultModel)
///   ✓ bắt lỗi Dio
///
/// Đây là lớp duy nhất biết về HTTP.
/// ===========================================================================
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._client);

  /// ApiClient là wrapper chứa Dio, interceptor, base URL, header…
  final ApiClient _client;

  /// ------------------------------------------------------------------------
  /// LOGIN API
  /// ------------------------------------------------------------------------
  @override
  Future<LoginResultModel> login(LoginRequest request) async {
    try {
      /// Gọi API POST /ex/api/login với body JSON
      final Response response = await _client.dio.post(
        '/ex/api/login',
        data: request.toJson(),
      );

      /// Server trả về Map JSON → chuyển sang Map<String, dynamic>
      final data = response.data as Map<String, dynamic>;

      /// Convert JSON → LoginResultModel (tầng DATA)
      return LoginResultModel.fromJson(data);
    }
    on DioException catch (e) {
      /// Khi API trả lỗi (4xx – 5xx), ta lấy message từ body nếu có
      final msg = e.response?.data is Map
          ? (e.response!.data['message']?.toString() ?? 'Login failed')
          : (e.message ?? 'Login failed');

      /// Quăng lỗi dạng Exception để Repository xử lý tiếp
      throw Exception(msg);
    }
  }

  /// ------------------------------------------------------------------------
  /// REGISTER TRIAL API
  /// ------------------------------------------------------------------------
  @override
  Future<List<dynamic>> registerTrial(TrialRegisterRequest request) async {
    try {
      /// Gọi API tạo tài khoản học thử
      final response = await _client.dio.post(
        '/ex/apiaffiliate/dangkytaikhoan1',
        data: request.toJson(),
      );

      /// Server trả về dạng List<dynamic>
      /// (theo API hiện tại, không có object cụ thể)
      return (response.data as List?) ?? [];
    }
    catch (e) {
      /// Bắt lỗi chung (cả DioException & error khác)
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> forgotPassword(String phone) async {
    // TODO: sửa URL + body theo API thật
    // ví dụ:
    await  _client.dio.post(
      '/ex/apikh/capnhattaikhoan',
      data: {'phone': phone},
    );
  }


}
