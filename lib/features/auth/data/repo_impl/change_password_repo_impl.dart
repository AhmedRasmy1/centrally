import 'package:centrally/core/common/api_result.dart';
import 'package:centrally/features/auth/data/data_sources/change_password_data_source.dart';
import 'package:centrally/features/auth/domain/entities/change_password_entity.dart';
import 'package:centrally/features/auth/domain/repo/change_password_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ChangePasswordRepo)
class ChangePasswordRepoImpl implements ChangePasswordRepo {
  final ChangePasswordDataSource dataSource;
  ChangePasswordRepoImpl(this.dataSource);

  @override
  Future<Result<ChangePasswordEntity>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) {
    final entity = ChangePasswordEntity(
      currentPassword: oldPassword,
      newPassword: newPassword,
    );
    return dataSource.changePassword(entity);
  }
}
