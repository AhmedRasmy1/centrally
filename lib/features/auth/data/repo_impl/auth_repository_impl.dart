import 'package:centrally/core/api/api_constants.dart';
import 'package:centrally/core/common/custom_exception.dart';
import 'package:centrally/features/auth/domain/repo/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);
  @override
  Future<void> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );

      if (response.statusCode != 200) {
        throw ServerError(
          statusCode: response.statusCode,
          message: response.data['message'] ?? 'Something went wrong',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw const NoInternetException();
      }
      throw ServerError(
        statusCode: e.response?.statusCode,
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }

  @override
  Future<void> resetPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.resetPassword,
        data: {'email': email, 'Otp': code, 'NewPassword': newPassword},
      );

      if (response.statusCode != 200) {
        throw ServerError(
          statusCode: response.statusCode,
          message: response.data['message'] ?? 'Something went wrong',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw const NoInternetException();
      }
      throw ServerError(
        statusCode: e.response?.statusCode,
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }
}
