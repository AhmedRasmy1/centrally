import 'package:centrally/core/common/api_result.dart';
import 'package:centrally/features/auth/domain/entities/change_password_entity.dart';

abstract class ChangePasswordDataSource {
  Future<Result<String>> changePassword(ChangePasswordEntity entity);
}