class TrialRegisterRequest {

  final String hoten;
  final String dienthoai;
  final String email;
  final String username;
  final String password;

  const TrialRegisterRequest({
    required this.hoten,
    required this.dienthoai,
    required this.email,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    // TODO: sửa key cho khớp API thật (AccountRegister ở backend)

    'hoten': hoten,
    'dienthoai': dienthoai,
    'email': email,
    'username': username,
    'password': password,
  };
}
