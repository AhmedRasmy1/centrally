import 'package:centrally/core/common/api_result.dart';
import 'package:centrally/features/auth/domain/entities/login_entity.dart';

abstract class LoginDataSource {
  Future<Result<LoginEntity>> login(String email, String password);
}
