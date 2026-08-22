import 'package:centrally/core/common/api_result.dart';
import 'package:centrally/features/auth/domain/entities/login_entity.dart';
import 'package:centrally/features/auth/domain/repo/login_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  final LoginRepo loginRepo;

  LoginUseCase(this.loginRepo);

  Future<Result<LoginEntity>> call(String email, String password) {
    return loginRepo.login(email, password);
  }
}
