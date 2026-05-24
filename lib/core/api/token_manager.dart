import 'dart:developer';
import 'package:centrally/core/utils/secure_storage_helper.dart';
import 'package:injectable/injectable.dart';

@singleton
class TokenManager {
  const TokenManager(this._secureStorage);

  final SecureStorage _secureStorage;

  // ── Save all tokens at once (used after login and after refresh) ──────────
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String role,
    required String teacherId,
  }) async {
    await Future.wait([
      _secureStorage.write(key: StorageKeys.userToken, value: accessToken),
      _secureStorage.write(key: StorageKeys.refreshToken, value: refreshToken),
      _secureStorage.write(key: StorageKeys.userRole, value: role),
      _secureStorage.write(key: StorageKeys.teacherId, value: teacherId),
    ]);
    log('tokens saved', name: 'TokenManager');
  }

  // ── Read ──────────────────────────────────────────────────────────────────
  Future<String?> getAccessToken() =>
      _secureStorage.read(StorageKeys.accessToken);
  Future<String?> getRefreshToken() =>
      _secureStorage.read(StorageKeys.refreshToken);
  Future<String?> getRole() => _secureStorage.read(StorageKeys.userRole);
  Future<String?> getTeacherId() => _secureStorage.read(StorageKeys.teacherId);

  // ── Used on logout or when refresh token expires ──────────────────────────
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    log('all tokens cleared', name: 'TokenManager');
  }

  // ── Quick check before making authenticated requests ──────────────────────
  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
