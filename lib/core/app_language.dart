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
}
