import 'package:injectable/injectable.dart';
import 'package:centrally/core/common/api_result.dart';
import 'package:centrally/features/auth/domain/repo/change_password_repo.dart';

@injectable
class ChangePasswordUseCase {
  final ChangePasswordRepo _repo;

  ChangePasswordUseCase(this._repo);

  Future<Result<void>> call({
    required String oldPassword,
    required String newPassword,
  }) {
    return _repo.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}