class LoginEntity {
  final String accessToken;
  final String refreshToken;
  final String role;
  final String teacherId;

  LoginEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.teacherId,
  });
}
