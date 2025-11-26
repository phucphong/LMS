import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // ===== KEYS =====
  static const String keyUsername     = 'username';
  static const String keyToken        = 'token';
  static const String keyRefreshToken = 'refresh_token';

  // Android options: dùng EncryptedSharedPreferences
  static const AndroidOptions _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  // iOS options: unlock được sau lần mở máy đầu tiên
  static const IOSOptions _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  // KHÔNG dùng const ở đây
  static final FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: _androidOptions,
    iOptions: _iosOptions,
  );

  // ===== WRITE =====
  static Future<void> saveUsername(String username) async {
    await _storage.write(key: keyUsername, value: username);
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: keyToken, value: token);
  }

  static Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: keyRefreshToken, value: refreshToken);
  }

  // ===== READ =====
  static Future<String?> readUsername() async {
    return _storage.read(key: keyUsername);
  }

  static Future<String?> readToken() async {
    return _storage.read(key: keyToken);
  }

  static Future<String?> readRefreshToken() async {
    return _storage.read(key: keyRefreshToken);
  }

  // ===== CLEAR =====
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
