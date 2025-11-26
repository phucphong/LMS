import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ngôn ngữ app hỗ trợ
enum AppLanguage { vi, en, zh, ja, ko }

/// Provider giữ trạng thái ngôn ngữ hiện tại
final appLanguageProvider = StateProvider<AppLanguage>((_) => AppLanguage.vi);

/// String resource đơn giản
class AppStrings {
  final AppLanguage lang;

  const AppStrings(this.lang);

  String get appTitle => 'LMS';

  // --- Login texts ---
  String get loginTitle => switch (lang) {
    AppLanguage.vi => 'Đăng nhập hệ thống LMS',
    AppLanguage.en => 'LMS Login',
    AppLanguage.zh => '登录 LMS 系统',
    AppLanguage.ja => 'LMS ログイン',
    AppLanguage.ko => 'LMS 로그인',
  };
  String get selectLanguageTitle => switch (lang) {
    AppLanguage.vi => 'Chọn ngôn ngữ',
    AppLanguage.en => 'Chọn ngôn ngữ',
    AppLanguage.zh => 'Chọn ngôn ngữ',
    AppLanguage.ja => 'Chọn ngôn ngữ',
    AppLanguage.ko => 'Chọn ngôn ngữ',
  };

  String get usernameLabel => switch (lang) {
    AppLanguage.vi => 'Tài khoản',
    AppLanguage.en => 'Username',
    AppLanguage.zh => '账号',
    AppLanguage.ja => 'ユーザー名',
    AppLanguage.ko => '아이디',
  };

  String get passwordLabel => switch (lang) {
    AppLanguage.vi => 'Mật khẩu',
    AppLanguage.en => 'Password',
    AppLanguage.zh => '密码',
    AppLanguage.ja => 'パスワード',
    AppLanguage.ko => '비밀번호',
  };

  String get usernameRequired => switch (lang) {
    AppLanguage.vi => 'Nhập tài khoản',
    AppLanguage.en => 'Enter username',
    AppLanguage.zh => '请输入账号',
    AppLanguage.ja => 'ユーザー名を入力してください',
    AppLanguage.ko => '아이디를 입력하세요',
  };

  String get passwordRequired => switch (lang) {
    AppLanguage.vi => 'Nhập mật khẩu',
    AppLanguage.en => 'Enter password',
    AppLanguage.zh => '请输入密码',
    AppLanguage.ja => 'パスワードを入力してください',
    AppLanguage.ko => '비밀번호를 입력하세요',
  };

  String get loginButton => switch (lang) {
    AppLanguage.vi => 'Đăng nhập',
    AppLanguage.en => 'Sign in',
    AppLanguage.zh => '登录',
    AppLanguage.ja => 'ログイン',
    AppLanguage.ko => '로그인',
  };

  String get loginSuccess => switch (lang) {
    AppLanguage.vi => 'Đăng nhập thành công',
    AppLanguage.en => 'Login successful',
    AppLanguage.zh => '登录成功',
    AppLanguage.ja => 'ログイン成功',
    AppLanguage.ko => '로그인 성공',
  };

  String get loginError => switch (lang) {
    AppLanguage.vi => 'Tài khoản hoặc mật khẩu không đúng!',
    AppLanguage.en => 'Invalid username or password!',
    AppLanguage.zh => '账号或密码不正确！',
    AppLanguage.ja => 'ユーザー名またはパスワードが正しくありません！',
    AppLanguage.ko => '아이디 또는 비밀번호가 올바르지 않습니다!',
  };

  // --- Thêm phần UI login khác ---
  String get rememberMe => switch (lang) {
    AppLanguage.vi => 'Lưu mật khẩu',
    AppLanguage.en => 'Remember me',
    AppLanguage.zh => '记住密码',
    AppLanguage.ja => 'パスワードを保存',
    AppLanguage.ko => '비밀번호 저장',
  };

  String get forgotPassword => switch (lang) {
    AppLanguage.vi => 'Quên mật khẩu',
    AppLanguage.en => 'Forgot password',
    AppLanguage.zh => '忘记密码',
    AppLanguage.ja => 'パスワードをお忘れですか？',
    AppLanguage.ko => '비밀번호를 잊으셨나요?',
  };

  String get registerAccount => switch (lang) {
    AppLanguage.vi => 'Đăng ký tài khoản',
    AppLanguage.en => 'Create account',
    AppLanguage.zh => '注册账号',
    AppLanguage.ja => 'アカウント登録',
    AppLanguage.ko => '계정 만들기',
  };
// Bạn chưa có tài khoản?
  String get noAccount => switch (lang) {
    AppLanguage.vi => 'Bạn chưa có tài khoản? ',
    AppLanguage.en => 'No account? ',
    AppLanguage.zh => '还没有账号？',
    AppLanguage.ja => 'アカウントがありませんか？',
    AppLanguage.ko => '아직 계정이 없나요? ',
  };

// Đăng ký ngay
  String get registerNow => switch (lang) {
    AppLanguage.vi => 'Đăng ký ngay',
    AppLanguage.en => 'Register now',
    AppLanguage.zh => '立即注册',
    AppLanguage.ja => '今すぐ登録',
    AppLanguage.ko => '지금 가입하기',
  };



  String copyright(String owner) => switch (lang) {
    AppLanguage.vi => 'Copyright © 2025 by $owner',
    AppLanguage.en => 'Copyright © 2025 by $owner',
    AppLanguage.zh => '版权所有 © 2025 $owner',
    AppLanguage.ja => 'Copyright © 2025 $owner',
    AppLanguage.ko => 'Copyright © 2025 $owner',
  };

  String versionLabel(String version) => switch (lang) {
    AppLanguage.vi => 'Phiên bản: $version',
    AppLanguage.en => 'Version: $version',
    AppLanguage.zh => '版本：$version',
    AppLanguage.ja => 'バージョン：$version',
    AppLanguage.ko => '버전: $version',
  };

  // --- Cho SelectLanguage ---
  String get shortCode => switch (lang) {
    AppLanguage.vi => 'VI',
    AppLanguage.en => 'EN',
    AppLanguage.zh => '中文',
    AppLanguage.ja => '日本語',
    AppLanguage.ko => '한국어',
  };

  String get languageName => switch (lang) {
    AppLanguage.vi => 'Tiếng Việt',
    AppLanguage.en => 'English',
    AppLanguage.zh => '中文（简体）',
    AppLanguage.ja => '日本語',
    AppLanguage.ko => '한국어',
  };

  String get flagEmoji => switch (lang) {
    AppLanguage.vi => '🇻🇳',
    AppLanguage.en => '🇺🇸',
    AppLanguage.zh => '🇨🇳',
    AppLanguage.ja => '🇯🇵',
    AppLanguage.ko => '🇰🇷',
  };



  // ==== Register Trial ====
  String get registerTrialTitle => switch (lang) {
    AppLanguage.vi => 'Đăng ký tài khoản',
    AppLanguage.en => 'Register account',
    AppLanguage.zh => 'Đăng ký tài khoản',
    AppLanguage.ja => 'Đăng ký tài khoản',
    AppLanguage.ko => 'Đăng ký tài khoản',
  };

  String get whoAreYou => switch (lang) {
    AppLanguage.vi => 'Bạn là phụ huynh hay học sinh?',
    AppLanguage.en => 'Are you a parent or a student?',
    AppLanguage.zh => '您是家长还是学生？',
    AppLanguage.ja => '保護者ですか？生徒ですか？',
    AppLanguage.ko => '학부모이신가요, 학생이신가요?',
  };

  String get parentOption => switch (lang) {
    AppLanguage.vi => 'Phụ huynh',
    AppLanguage.en => 'Parent',
    AppLanguage.zh => '家长',
    AppLanguage.ja => '保護者',
    AppLanguage.ko => '학부모',
  };

  String get studentOption => switch (lang) {
    AppLanguage.vi => 'Học sinh',
    AppLanguage.en => 'Student',
    AppLanguage.zh => '学生',
    AppLanguage.ja => '生徒',
    AppLanguage.ko => '학생',
  };

  String get fullNameLabel => switch (lang) {
    AppLanguage.vi => 'Họ và tên',
    AppLanguage.en => 'Full name',
    AppLanguage.zh => '姓名',
    AppLanguage.ja => '氏名',
    AppLanguage.ko => '이름',
  };

  String get fullNameHint => switch (lang) {
    AppLanguage.vi => 'Họ và tên',
    AppLanguage.en => 'Your full name',
    AppLanguage.zh => '请输入姓名',
    AppLanguage.ja => '氏名を入力してください',
    AppLanguage.ko => '이름을 입력하세요',
  };

  String get phoneLabel => switch (lang) {
    AppLanguage.vi => 'Số điện thoại',
    AppLanguage.en => 'Phone number',
    AppLanguage.zh => '手机号',
    AppLanguage.ja => '電話番号',
    AppLanguage.ko => '전화번호',
  };


  String get phoneHint => switch (lang) {
    AppLanguage.vi => 'Số điện thoại',
    AppLanguage.en => 'Phone number',
    AppLanguage.zh => '请输入手机号',
    AppLanguage.ja => '電話番号を入力してください',
    AppLanguage.ko => '전화번호를 입력하세요',
  };



  String get emailLabel => switch (lang) {
    AppLanguage.vi => 'Email',
    AppLanguage.en => 'Email',
    AppLanguage.zh => 'Email',
    AppLanguage.ja => 'Email',
    AppLanguage.ko => 'Email',
  };
  String get emailHint => switch (lang) {
    AppLanguage.vi => 'Email',
    AppLanguage.en => 'Email',
    AppLanguage.zh => 'Email',
    AppLanguage.ja => 'Email',
    AppLanguage.ko => 'Email',
  };


  String get accountLabel => switch (lang) {
    AppLanguage.vi => 'Tài khoản',
    AppLanguage.en => 'Account',
    AppLanguage.zh => 'Tài khoản',
    AppLanguage.ja => 'Tài khoản',
    AppLanguage.ko => 'Tài khoản',
  };
  String get accountHint => switch (lang) {
    AppLanguage.vi => 'Tài khoản',
    AppLanguage.en => 'Account',
    AppLanguage.zh => 'Tài khoản',
    AppLanguage.ja => 'Tài khoản',
    AppLanguage.ko => 'Tài khoản',
  };

  String get gradeLabel => switch (lang) {
    AppLanguage.vi => 'Khối lớp',
    AppLanguage.en => 'Grade',
    AppLanguage.zh => '年级',
    AppLanguage.ja => '学年',
    AppLanguage.ko => '학년',
  };

  String get gradeHint => switch (lang) {
    AppLanguage.vi => 'Chọn khối lớp',
    AppLanguage.en => 'Select grade',
    AppLanguage.zh => '选择年级',
    AppLanguage.ja => '学年を選択',
    AppLanguage.ko => '학년 선택',
  };

  String get registerButton => switch (lang) {
    AppLanguage.vi => 'Đăng ký',
    AppLanguage.en => 'Register',
    AppLanguage.zh => 'Đăng ký',
    AppLanguage.ja => 'Đăng ký',
    AppLanguage.ko => 'Đăng ký',
  };

  String get registerTrialDescription => switch (lang) {
    AppLanguage.vi =>
    'Nếu bạn đã kích hoạt tài khoản hoặc có tài khoản miễn phí do trường cung cấp, vui lòng',
    AppLanguage.en =>
    'If you already have an activated account or a free account provided by your school, please',
    AppLanguage.zh => '如果您已经激活账号或拥有学校提供的免费账号，请',
    AppLanguage.ja => 'すでに有効なアカウント、または学校から提供された無料アカウントをお持ちの場合は、',
    AppLanguage.ko => '이미 활성화된 계정이나 학교에서 제공한 무료 계정이 있다면,',
  };

  String get loginHere => switch (lang) {
    AppLanguage.vi => 'Đăng nhập tại đây',
    AppLanguage.en => 'log in here',
    AppLanguage.zh => '在此登录',
    AppLanguage.ja => 'こちらからログイン',
    AppLanguage.ko => '여기에서 로그인',
  };

  String get registerTrialSuccess => switch (lang) {
    AppLanguage.vi => 'Đăng ký học thử thành công',
    AppLanguage.en => 'Trial registration successful',
    AppLanguage.zh => '试听注册成功',
    AppLanguage.ja => '体験登録が完了しました',
    AppLanguage.ko => '무료 체험 신청이 완료되었습니다',
  };

  String get fullNameRequired => switch (lang) {
    AppLanguage.vi => 'Vui lòng nhập họ và tên',
    AppLanguage.en => 'Please enter full name',
    AppLanguage.zh => '请输入姓名',
    AppLanguage.ja => '氏名を入力してください',
    AppLanguage.ko => '이름을 입력해 주세요',
  };

  String get phoneRequired => switch (lang) {
    AppLanguage.vi => 'Vui lòng nhập số điện thoại',
    AppLanguage.en => 'Please enter phone number',
    AppLanguage.zh => '请输入手机号',
    AppLanguage.ja => '電話番号を入力してください',
    AppLanguage.ko => '전화번호를 입력해 주세요',
  };
  String get emailRequired => switch (lang) {
    AppLanguage.vi => 'Vui lòng nhập email',
    AppLanguage.en => 'Please enter email',
    AppLanguage.zh => 'Vui lòng nhập email',
    AppLanguage.ja => 'Vui lòng nhập email',
    AppLanguage.ko => 'Vui lòng nhập email',
  };
  String get accountRequired => switch (lang) {
    AppLanguage.vi => 'Vui lòng nhập tài khoản',
    AppLanguage.en => 'Please enter Account',
    AppLanguage.zh => 'Vui lòng nhập tài khoản',
    AppLanguage.ja => 'Vui lòng nhập tài khoản',
    AppLanguage.ko => 'Vui lòng nhập tài khoản',
  };


  String get gradeRequired => switch (lang) {
    AppLanguage.vi => 'Vui lòng chọn khối lớp',
    AppLanguage.en => 'Please select grade',
    AppLanguage.zh => '请选择年级',
    AppLanguage.ja => '学年を選択してください',
    AppLanguage.ko => '학년을 선택해 주세요',
  };
}
