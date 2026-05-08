import 'package:dio/dio.dart';

class ServerError implements Exception {
  const ServerError({required this.statusCode, required this.message});

  final int? statusCode;
  final String message;

  @override
  String toString() => 'ServerError($statusCode): $message';
}

class DioHttpException implements Exception {
  const DioHttpException(this.exception);

  final DioException exception;

  @override
  String toString() => 'DioHttpException: ${exception.message}';
}

class NoInternetException implements Exception {
  const NoInternetException();

  @override
  String toString() => 'NoInternetException: No internet connection';
}
