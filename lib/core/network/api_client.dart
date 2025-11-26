import 'package:dio/dio.dart';

class ApiClient {
  ApiClient()
      : _dio = Dio(
    BaseOptions(
      baseUrl: 'https://aff.ezmax.vn', // TODO: đổi sang domain thật
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: const {
        'Content-Type': 'application/json',
      },
    ),
  ) {
    // Optional: log request/response
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  final Dio _dio;

  Dio get dio => _dio;
}
