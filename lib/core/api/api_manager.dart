import 'package:centrally/core/api/api_constants.dart';
import 'package:centrally/features/auth/data/model/login_model.dart';
import 'package:centrally/features/auth/data/model/logout_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiManager {
  final Dio _dio;

  ApiManager() : _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Dio get dio => _dio;

  Future<LoginModel> login(String email, String password) async {
    final response = await _dio.post(
      ApiConstants.loginEndpoint,
      data: {'email': email, 'password': password},
    );
    return LoginModel.fromJson(response.data);
  }

  Future<LogoutModel> logout(String refreshToken) async {
    final response = await _dio.post(
      ApiConstants.logoutEndpoint,
      data: {'refreshToken': refreshToken},
    );
    return LogoutModel.fromJson(response.data);
  }
}
