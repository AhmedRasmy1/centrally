import 'package:centrally/core/api/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
@injectable
class ApiManager {
  ApiManager() : _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  final Dio _dio;

  Dio get dio => _dio;
}
