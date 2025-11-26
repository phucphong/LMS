class TrialRegisterRequest {
  final bool isParent; // true = phụ huynh, false = học sinh
  final String fullName;
  final String phone;
  final String grade; // ví dụ: "Lớp 1", "Lớp 2", ...

  const TrialRegisterRequest({
    required this.isParent,
    required this.fullName,
    required this.phone,
    required this.grade,
  });

  Map<String, dynamic> toJson() => {
    // TODO: sửa key cho khớp API thật (AccountRegister ở backend)
    'type': isParent ? 'PH' : 'HS',
    'full_name': fullName,
    'phone': phone,
    'grade': grade,
  };
}
