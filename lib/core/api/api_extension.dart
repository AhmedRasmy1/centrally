import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:centrally/core/common/api_result.dart';
import 'package:centrally/core/common/custom_exception.dart';
import 'package:dio/dio.dart';

Future<Result<T>> executeApi<T>(Future<T> Function() apiCall) async {
  try {
    final result = await apiCall();
    return Success(result);
  } on TimeoutException catch (_) {
    return const Failure(NoInternetException());
  } on DioException catch (ex) {
    final message = _extractMessage(ex);
    log('DioException: $message', name: 'ApiExtension');

    if (ex.response != null) {
      return Failure(
        ServerError(
          statusCode: ex.response?.statusCode,
          message: message,
        ),
      );
    }
    return Failure(DioHttpException(ex));
  } on IOException catch (_) {
    return const Failure(NoInternetException());
  } on Exception catch (ex) {
    return Failure(ex);
  }
}

String _extractMessage(DioException ex) {
  try {
    final data = ex.response?.data;
    if (data is Map<String, dynamic>) {
      return (data['message'] as String?) ?? 'The server returned an error';
    }
    return 'The server returned an error';
  } catch (_) {
    return 'The server returned an error';
  }
}
