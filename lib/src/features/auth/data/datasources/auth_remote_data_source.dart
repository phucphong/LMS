
import 'package:dio/dio.dart';

import '../../../../../core/network/api_client.dart';
import '../models/login_request.dart';
import '../models/login_result_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResultModel> login(LoginRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<LoginResultModel> login(LoginRequest request) async {
    try {
      final Response response = await _client.dio.post(
        '/ex/api/login',
        data: request.toJson(), // JSON body
      );

      // tuỳ response: anh check thử log để map cho chuẩn
      final data = response.data as Map<String, dynamic>;
      return LoginResultModel.fromJson(data);
    } on DioException catch (e) {
      // gộp error message
      final msg = e.response?.data is Map
          ? (e.response!.data['message']?.toString() ?? 'Login failed')
          : (e.message ?? 'Login failed');
      throw Exception(msg);
    }
  }
}
