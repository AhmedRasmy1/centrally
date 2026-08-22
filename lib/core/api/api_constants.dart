class ApiConstants {
  static const String baseUrl = 'https://centerly.runasp.net/api';
  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';

  // Request Body Keys
  static const String refreshTokenKey = 'refreshToken';

  // Headers
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}
