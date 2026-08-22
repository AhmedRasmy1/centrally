import 'package:centrally/core/api/api_constants.dart';
import 'package:centrally/core/api/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio providerDio() {
    final Dio dio = Dio();
    dio.interceptors.add(
      PrettyDioLogger(
        responseBody: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
    return dio;
  }

  // ── Plain Dio: no interceptor ─────────────
  @Named('plainDio')
  @singleton
  Dio providePlainDio() => Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  // ── Main Dio: AuthInterceptor + logger ───────────────────
  @Named('mainDio')
  @singleton
  Dio provideMainDio(AuthInterceptor authInterceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    dio.interceptors.addAll([
      authInterceptor,
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    ]);
    DioRetryClient.instance = dio;
    return dio;
  }
}
