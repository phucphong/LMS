import '../../domain/entities/login_result.dart';

class LoginResultModel extends LoginResult {
  const LoginResultModel({
    required super.token,
    required super.idnhanvien,
    required super.hoten,
  });

  factory LoginResultModel.fromJson(Map<String, dynamic> json) {
    return LoginResultModel(
      token: json['token']?.toString() ?? '',
      idnhanvien: json['idnhanvien']?.toString() ?? '',
      hoten: json['hoten']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'idnhanvien': idnhanvien,
      'hoten': hoten,
    };
  }
}
