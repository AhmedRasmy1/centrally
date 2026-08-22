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

import '../../features/auth/data/data_sources/login_data_source.dart' as _i466;
import '../../features/auth/data/data_sources/logout_data_source.dart' as _i697;
import '../../features/auth/data/data_sources_impl/login_data_source_impl.dart'
    as _i785;
import '../../features/auth/data/data_sources_impl/logout_data_source_impl.dart'
    as _i311;
import '../../features/auth/data/repo_impl/login_repo_impl.dart' as _i204;
import '../../features/auth/data/repo_impl/logout_repo_impl.dart' as _i748;
import '../../features/auth/domain/repo/login_repo.dart' as _i543;
import '../../features/auth/domain/repo/logout_repo.dart' as _i295;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/presentation/view_models/login_view_model/login_cubit.dart'
    as _i1045;
import '../../features/auth/presentation/view_models/logout_view_model/logout_cubit.dart'
    as _i177;
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
    gh.factory<_i697.LogoutDataSource>(
      () => _i311.LogoutDataSourceImpl(gh<_i1047.ApiManager>()),
    );
    gh.factory<_i466.LoginDataSource>(
      () => _i785.LoginDataSourceImpl(gh<_i1047.ApiManager>()),
    );
    gh.factory<_i295.LogoutRepo>(
      () => _i748.LogoutRepoImpl(gh<_i697.LogoutDataSource>()),
    );
    gh.factory<_i48.LogoutUsecase>(
      () => _i48.LogoutUsecase(logoutRepo: gh<_i295.LogoutRepo>()),
    );
    gh.factory<_i543.LoginRepo>(
      () => _i204.LoginRepoImpl(gh<_i466.LoginDataSource>()),
    );
    gh.factory<_i177.LogoutCubit>(
      () => _i177.LogoutCubit(gh<_i48.LogoutUsecase>()),
    );
    gh.factory<_i188.LoginUseCase>(
      () => _i188.LoginUseCase(gh<_i543.LoginRepo>()),
    );
    gh.factory<_i1045.LoginCubit>(
      () => _i1045.LoginCubit(gh<_i188.LoginUseCase>()),
    );
    return this;
  }
}

class _$DioModule extends _i0.DioModule {}
