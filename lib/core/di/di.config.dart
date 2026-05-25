// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/data_sources/change_password_data_source.dart'
    as _i834;
import '../../features/auth/data/data_sources_impl/change_password_source_impl.dart'
    as _i235;
import '../../features/auth/data/repo_impl/change_password_repo_impl.dart'
    as _i399;
import '../../features/auth/domain/repo/change_password_repo.dart' as _i648;
import '../../features/auth/domain/usecases/change_password_usecase.dart'
    as _i788;
import '../../features/auth/presentation/view_models/change_password_view_model/change_password_cubit.dart'
    as _i833;
import '../api/api_manager.dart' as _i1047;
import '../api/api_module.dart' as _i0;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    gh.singleton<_i1047.ApiManager>(() => _i1047.ApiManager());
    gh.lazySingleton<_i361.Dio>(() => dioModule.providerDio());
    gh.factory<_i834.ChangePasswordDataSource>(
      () => _i235.ChangePasswordDataSourceImpl(gh<_i1047.ApiManager>()),
    );
    gh.factory<_i648.ChangePasswordRepo>(
      () => _i399.ChangePasswordRepoImpl(gh<_i834.ChangePasswordDataSource>()),
    );
    gh.factory<_i788.ChangePasswordUseCase>(
      () => _i788.ChangePasswordUseCase(gh<_i648.ChangePasswordRepo>()),
    );
    gh.factory<_i833.ChangePasswordCubit>(
      () => _i833.ChangePasswordCubit(gh<_i788.ChangePasswordUseCase>()),
    );
    return this;
  }
}

class _$DioModule extends _i0.DioModule {}
