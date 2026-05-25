abstract class AuthRepository {
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String email, String code, String newPassword);
}
