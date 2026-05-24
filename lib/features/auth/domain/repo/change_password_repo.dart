import 'package:centrally/core/common/api_result.dart';


abstract class ChangePasswordRepo {
  Future<Result<void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}