import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
class SecureStorage {
  const SecureStorage()
    : _storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );

  final FlutterSecureStorage _storage;

  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<void> deleteAll() => _storage.deleteAll();
}

abstract final class StorageKeys {
  static const String userToken = 'USER_TOKEN';
  static const String userId = 'USER_ID';
  static const String languageCode = 'LANGUAGE_CODE';
  static const String accessToken = 'ACCESS_TOKEN';
  static const String refreshToken = 'REFRESH_TOKEN';
  static const String userRole = 'USER_ROLE';
  static const String teacherId = 'TEACHER_ID';
}
