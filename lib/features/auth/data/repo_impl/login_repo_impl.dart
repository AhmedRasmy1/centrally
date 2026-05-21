import 'package:centrally/core/common/api_result.dart';
import 'package:centrally/features/auth/data/data_sources/login_data_source.dart';
import 'package:centrally/features/auth/domain/entities/login_entity.dart';
import 'package:centrally/features/auth/domain/repo/login_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LoginRepo)
class LoginRepoImpl implements LoginRepo {
  final LoginDataSource loginDataSource;
  LoginRepoImpl(this.loginDataSource);

  @override
  Future<Result<LoginEntity>> login(String email, String password) {
    return loginDataSource.login(email, password);
  }
}
