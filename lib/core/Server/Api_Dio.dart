import 'package:dio/dio.dart';
import 'package:lms/core/utils/Constatns.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: CS.Api,
        ));

  Future<Response> get(String endpoint, {String? token}) async {
    final options = Options(
      headers: token != null
          ? {
              'Authorization': 'Bearer $token',
            }
          : null,
    );

    final response = await _dio.get(endpoint, options: options);
    return response;
  }

  Future<Response> post(String endpoint, {
    String? token,
    dynamic data,
  }) async {
    final options = Options(
      headers: token != null
          ? {
              'Authorization': 'Bearer $token',
            }
          : null,
    );

    final response = await _dio.post(endpoint, data: data, options: options);
    return response;
  }
}