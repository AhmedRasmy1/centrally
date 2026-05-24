import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:centrally/core/common/api_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:centrally/features/auth/domain/usecases/change_password_usecase.dart';


part 'change_password_state.dart';
part 'change_password_cubit.freezed.dart';

@injectable
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordCubit(this._changePasswordUseCase)
      : super(const ChangePasswordState.initial());

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(const ChangePasswordState.loading());

    final result = await _changePasswordUseCase.call(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    switch (result) {
      case Success():
        emit(const ChangePasswordState.success());
        break;

      case Failure():
        emit(
          ChangePasswordState.failure(
            result.exception.toString(),
          ),
        );

        log('Change Password Error: ${result.exception}');
        break;
    }
  }
}