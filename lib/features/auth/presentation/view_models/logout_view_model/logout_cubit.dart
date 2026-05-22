import 'package:bloc/bloc.dart';
import 'package:centrally/core/common/api_result.dart';
import 'package:centrally/features/auth/domain/entities/logout_entity.dart';
import 'package:centrally/features/auth/domain/usecases/logout_usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'logout_state.dart';
part 'logout_cubit.freezed.dart';

@injectable
class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUsecase logoutUsecase;
  LogoutCubit(this.logoutUsecase) : super(const LogoutState.initial());
  Future<void> logout(String refreshToken) async {
    emit(const LogoutState.loading());
    final result = await logoutUsecase.call(refreshToken);
    switch (result) {
      case Success<LogoutEntity>():
        emit(LogoutState.success(result.data));
        break;
      case Failure<LogoutEntity>():
        emit(LogoutState.failure(result.exception.toString()));
        break;
    }
  }
}
