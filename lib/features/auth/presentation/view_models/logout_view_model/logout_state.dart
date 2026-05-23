part of 'logout_cubit.dart';

@freezed
class LogoutState with _$LogoutState {
  const factory LogoutState.initial() = _Initial;
  const factory LogoutState.loading() = _Loading;
  const factory LogoutState.success(LogoutEntity logoutEntity) = _Success;
  const factory LogoutState.failure(String error) = _Failure;
}
