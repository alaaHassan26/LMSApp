import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lms/cache/cache_helper.dart';

import '../../../../core/Server/Api_Dio.dart';
import '../../../../core/Server/Error_Failures.dart';
import '../Model/login_model.dart';

class LoginRepository {
  final ApiService apiService = ApiService();

  LoginRepository();

  Future<Either<Failure, LoginResponse>> loginUser(
      String email, String password) async {
    try {
      final response = await apiService.post(
        'api/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final loginResponse = LoginResponse.fromJson(response.data);
      CacheHelper().saveData(key: 'saveToken', value: loginResponse.token);
      return Right(loginResponse);
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          final errorMessage = e.response?.data['message'] ?? '';
          return Left(ServerFailure(errorMessage));
        } else {
          return Left(ServerFailure.fromDioError(e));
        }
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, LoginResponse>> loginWithCode(
      String macAddress, String loginCode) async {
    try {
      final response = await apiService.post(
        'api/login',
        data: {
          'mac_address': macAddress,
          'login_code': loginCode,
        },
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      final loginResponse = LoginResponse.fromJson(response.data);
      print("LoginResponse: $loginResponse");
      CacheHelper().saveData(key: 'saveToken', value: loginResponse.token);
      return Right(loginResponse);
    } catch (e) {
      print("Error: $e");
      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          final errorMessage = e.response?.data['message'] ?? '';
          return Left(ServerFailure(errorMessage));
        } else {
          return Left(ServerFailure.fromDioError(e));
        }
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
