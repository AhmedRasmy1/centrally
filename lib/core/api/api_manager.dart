import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:centrally/core/api/api_constants.dart';
import 'package:centrally/features/auth/data/model/change_password_model.dart';

@singleton
class ApiManager {
  final Dio _dio;

  ApiManager() : _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Dio get dio => _dio;

  Future<ChangePasswordModel> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    // final token = CacheService.getData(key: CacheConstants.userToken);

    final response = await _dio.post(
      ApiConstants.changePasswordEndpoint,
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      options: Options(
        headers: {
          // 'Authorization': 'Bearer $token',
        },
      ),
    );

    return ChangePasswordModel.fromJson(response.data);
  }
}
