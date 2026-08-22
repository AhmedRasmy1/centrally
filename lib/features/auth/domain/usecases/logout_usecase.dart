import 'package:centrally/core/common/api_result.dart';
import 'package:centrally/features/auth/domain/entities/logout_entity.dart';
import 'package:centrally/features/auth/domain/repo/logout_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUsecase {
  LogoutRepo logoutRepo;
  LogoutUsecase({required this.logoutRepo});
  Future<Result<LogoutEntity>> call(String refreshToken) async {
    return await logoutRepo.logout(refreshToken);
  }
}
