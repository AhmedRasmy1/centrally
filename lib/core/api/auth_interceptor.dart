import 'dart:async';
import 'dart:developer';
import 'package:centrally/core/api/api_constants.dart';
import 'package:centrally/core/api/auth_event_bus.dart';
import 'package:centrally/core/api/refresh_token_service.dart';
import 'package:centrally/core/api/token_manager.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class AuthInterceptor extends QueuedInterceptorsWrapper {
  AuthInterceptor(this._tokenManager, this._refreshService, this._authEventBus);

  final TokenManager _tokenManager;
  final RefreshTokenService _refreshService;
  final AuthEventBus _authEventBus;

  // Lock: only one refresh happens at a time
  // All other 401s wait for this Completer to complete
  Completer<String?>? _refreshCompleter;

  // ── Attach token to every outgoing request ────────────────────────────────
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_refreshCompleter != null) {
      log('waiting for ongoing refresh...', name: 'AuthInterceptor');
      final newToken = await _refreshCompleter!.future;
      if (newToken != null) {
        options.headers[ApiConstants.authorization] =
            '${ApiConstants.bearer} $newToken';
      }
      return handler.next(options);
    }

    final token = await _tokenManager.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.authorization] =
          '${ApiConstants.bearer} $token';
    }
    return handler.next(options);
  }

  // ── Handle 401 errors ─────────────────────────────────────────────────────
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final path = err.requestOptions.path;
    if (path.contains(ApiConstants.refreshTokenEndpoint) ||
        path.contains(ApiConstants.loginEndpoint) ||
        path.contains(ApiConstants.logoutEndpoint)) {
      return handler.next(err);
    }

    log('401 received — attempting token refresh', name: 'AuthInterceptor');

    if (_refreshCompleter != null) {
      log('refresh in progress — waiting', name: 'AuthInterceptor');
      final newToken = await _refreshCompleter!.future;
      if (newToken == null) return handler.next(err);
      return _retry(err.requestOptions, handler, newToken);
    }

    // This is the first 401 → start the refresh
    _refreshCompleter = Completer<String?>();

    final newToken = await _refreshService.refreshAccessToken();

    // Broadcast result to all requests that were waiting
    _refreshCompleter!.complete(newToken);
    _refreshCompleter = null;

    if (newToken == null) {
      log('refresh failed → logout', name: 'AuthInterceptor');
      _authEventBus.fire(AuthEvent.logout);
      return handler.next(err);
    }

    log(
      'refresh succeeded → retrying original request',
      name: 'AuthInterceptor',
    );
    return _retry(err.requestOptions, handler, newToken);
  }

  // ── Retry the original failed request with the new token ──────────────────
  Future<void> _retry(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
    String newToken,
  ) async {
    requestOptions.headers[ApiConstants.authorization] =
        '${ApiConstants.bearer} $newToken';
    try {
      final response = await DioRetryClient.instance.fetch(requestOptions);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}

/// Holds a reference to the main Dio instance for retrying requests.
/// Set once inside DioModule when mainDio is created.
class DioRetryClient {
  DioRetryClient._();
  static late Dio instance;
}
