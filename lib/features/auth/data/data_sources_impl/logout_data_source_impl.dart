import 'package:centrally/core/api/api_extension.dart';
import 'package:centrally/core/api/api_manager.dart';
import 'package:centrally/core/common/api_result.dart';
import 'package:centrally/features/auth/data/data_sources/logout_data_source.dart';
import 'package:centrally/features/auth/domain/entities/logout_entity.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LogoutDataSource)
class LogoutDataSourceImpl implements LogoutDataSource {
  final ApiManager apiManager;
  LogoutDataSourceImpl(this.apiManager);
  @override
  Future<Result<LogoutEntity>> logout(String refreshToken) async {
    return executeApi(() async {
      final response = await apiManager.logout(refreshToken);
      final data = response.toLogoutEntity();
      return data;
    });
  }
}
