import 'package:centrally/core/common/api_result.dart';
import 'package:centrally/features/auth/domain/entities/logout_entity.dart';

abstract class LogoutRepo {
  Future<Result<LogoutEntity>> logout(String refreshToken);
}
