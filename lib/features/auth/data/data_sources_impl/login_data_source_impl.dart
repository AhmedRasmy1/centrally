import 'package:centrally/core/api/api_extension.dart';
import 'package:centrally/core/api/api_manager.dart';
import 'package:centrally/core/common/api_result.dart';
import 'package:centrally/features/auth/data/data_sources/login_data_source.dart';
import 'package:centrally/features/auth/domain/entities/login_entity.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LoginDataSource)
class LoginDataSourceImpl implements LoginDataSource {
  final ApiManager apiManager;
  LoginDataSourceImpl(this.apiManager);
  @override
  Future<Result<LoginEntity>> login(String email, String password) {
    return executeApi(() async {
      final response = await apiManager.login(email, password);
      final data = response.toLoginEntity();
      return data;
    });
  }
}
