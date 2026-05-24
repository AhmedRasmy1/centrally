import 'package:injectable/injectable.dart';
import 'package:centrally/core/api/api_manager.dart';
import 'package:centrally/core/api/api_extension.dart';
import 'package:centrally/core/common/api_result.dart';
import 'package:centrally/features/auth/domain/entities/change_password_entity.dart';
import 'package:centrally/features/auth/data/data_sources/change_password_data_source.dart';

@Injectable(as: ChangePasswordDataSource)
class ChangePasswordDataSourceImpl implements ChangePasswordDataSource {
  final ApiManager apiManager;

  ChangePasswordDataSourceImpl(this.apiManager);

  @override
  Future<Result<String>> changePassword(ChangePasswordEntity entity) {
    return executeApi(() async {
      final response = await apiManager.changePassword(
        entity.currentPassword,
        entity.newPassword,
      );

    
     return "Password changed successfully";
    });
  }
}