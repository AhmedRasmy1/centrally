import 'package:centrally/core/common/api_result.dart';
import 'package:centrally/features/auth/domain/entities/change_password_entity.dart';

abstract class ChangePasswordRepo {
  Future<Result<ChangePasswordEntity>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}
