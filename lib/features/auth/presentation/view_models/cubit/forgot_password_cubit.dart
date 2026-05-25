import 'package:centrally/core/constants/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:centrally/core/common/custom_exception.dart';
import 'package:centrally/features/auth/domain/repo/auth_repository.dart';
import 'package:centrally/features/auth/presentation/view_models/cubit/forgot_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordCubit(this._authRepository)
    : super(const ForgotPasswordState.initial());

  Future<void> submitForgotPassword(String email) async {
    emit(const ForgotPasswordState.initial());
    try {
      emit(const ForgotPasswordState.loading());
      await _authRepository.forgotPassword(email);

      emit(const ForgotPasswordState.success());
    } on NoInternetException {
      emit(ForgotPasswordState.failure(StringsManager.noInternet.tr()));
    } on ServerError catch (e) {
      if (e.message.toLowerCase().contains('email') ||
          e.message.toLowerCase().contains('not found')) {
        emit(ForgotPasswordState.failure(StringsManager.emailNotFound.tr()));
      } else {
        emit(ForgotPasswordState.failure(e.message));
      }
    } catch (e) {
      emit(ForgotPasswordState.failure(StringsManager.unknownError.tr()));
    }
  }
}
