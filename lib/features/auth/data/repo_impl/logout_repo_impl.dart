import 'package:centrally/core/common/api_result.dart';
import 'package:centrally/features/auth/data/data_sources/logout_data_source.dart';
import 'package:centrally/features/auth/domain/entities/logout_entity.dart';
import 'package:centrally/features/auth/domain/repo/logout_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LogoutRepo)
class LogoutRepoImpl implements LogoutRepo {
  final LogoutDataSource logoutDataSource;
  LogoutRepoImpl(this.logoutDataSource);
  @override
  Future<Result<LogoutEntity>> logout(String refreshToken) {
    return logoutDataSource.logout(refreshToken);
  }
}
