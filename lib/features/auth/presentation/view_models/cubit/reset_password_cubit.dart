import 'package:centrally/features/auth/domain/repo/auth_repository.dart';
import 'package:centrally/features/auth/presentation/view_models/cubit/reset_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepository _authRepository;

  ResetPasswordCubit(this._authRepository)
    : super(const ResetPasswordState.initial());

  Future<void> submitResetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    emit(const ResetPasswordState.initial());
    try {
      emit(const ResetPasswordState.loading());
      await _authRepository.resetPassword(email, code, newPassword);

      emit(const ResetPasswordState.success());
    } catch (e) {
      emit(ResetPasswordState.failure(e.toString()));
    }
  }
}
