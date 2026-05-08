import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> set({required String key, required dynamic value}) async {
    if (value is int) return _prefs.setInt(key, value);
    if (value is String) return _prefs.setString(key, value);
    if (value is double) return _prefs.setDouble(key, value);
    if (value is bool) return _prefs.setBool(key, value);
    return false;
  }

  static dynamic get(String key) => _prefs.get(key);

  static Future<bool> remove(String key) => _prefs.remove(key);

  static Future<bool> clear() => _prefs.clear();
}

abstract final class CacheKeys {
  static const String userToken = 'user_token';
  static const String role = 'role';
  static const String userEmail = 'user_email';
  static const String userType = 'user_type';
  static const String technicianService = 'technician_service';
}
