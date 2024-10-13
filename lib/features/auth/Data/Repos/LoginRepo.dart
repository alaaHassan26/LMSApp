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
        '/api/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      var userName = loginResponse.result[0].name; 
      var userId = loginResponse.result[0].id; 
      var Image = loginResponse.result[0].image; 

CacheHelper().saveData(key: 'user_name', value: userName);

CacheHelper().saveData(key: 'user_Id', value: userId);
CacheHelper().saveData(key: 'user_image', value: Image);
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
        '/api/login',
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
var userName = loginResponse.result[0].name; 

print(userName! + '32r3rr3');
CacheHelper().saveData(key: 'user_name', value: userName);

      var userId = loginResponse.result[0].id; 

CacheHelper().saveData(key: 'user_Id', value: userId);
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
