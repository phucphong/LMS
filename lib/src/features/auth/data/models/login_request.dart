class LoginRequest {
  final String username;
  final String password;

  const LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    // TODO: nếu native gửi thêm deviceId, platform... thì add vào đây
  };
}
