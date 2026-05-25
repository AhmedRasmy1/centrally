// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:centrally/features/auth/presentation/view_models/cubit/reset_password_cubit.dart'
    as _i288;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/repo_impl/auth_repository_impl.dart' as _i756;
import '../../features/auth/domain/repo/auth_repository.dart' as _i2;
import '../../features/auth/presentation/view_models/cubit/forgot_password_cubit.dart'
    as _i288;

import '../api/api_module.dart' as _i0;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();

    gh.lazySingleton<_i361.Dio>(() => dioModule.providerDio());
    gh.lazySingleton<_i2.AuthRepository>(
      () => _i756.AuthRepositoryImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i288.ForgotPasswordCubit>(
      () => _i288.ForgotPasswordCubit(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i288.ResetPasswordCubit>(
      () => _i288.ResetPasswordCubit(gh<_i2.AuthRepository>()),
    );
    return this;
  }
}

class _$DioModule extends _i0.DioModule {}
