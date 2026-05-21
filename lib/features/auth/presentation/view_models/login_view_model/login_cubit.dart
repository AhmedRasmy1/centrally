import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:centrally/core/common/api_result.dart';
import 'package:centrally/core/utils/cached_data_shared_preferences.dart';
import 'package:centrally/features/auth/domain/entities/login_entity.dart';
import 'package:centrally/features/auth/domain/usecases/login_usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(const LoginState.initial());

  Future<void> login({required String email, required String password}) async {
    emit(const LoginState.loading());
    final result = await _loginUseCase.call(email, password);
    switch (result) {
      case Success<LoginEntity>():
        await Future.wait([
          CacheService.setData(
            key: CacheConstants.userToken,
            value: result.data.accessToken,
          ),
          CacheService.setData(
            key: CacheConstants.role,
            value: result.data.role,
          ),
        ]);

        emit(LoginState.success(result.data));
        log('=====================> ${result.data}');
        log('=====================> ${result.data.accessToken}');
        log('=====================> ${result.data.role}');
        break;
      case Failure<LoginEntity>():
        emit(LoginState.failure(result.exception.toString()));
        log('=====================> ${result.exception}');
        break;
    }
  }
}
