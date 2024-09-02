import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/Server/Api_Dio.dart';
import '../../../../core/Server/Error_Failures.dart';
import '../Model/login_email_model.dart';

class LoginRepository {
  final ApiService apiService = ApiService();

  LoginRepository();

  Future<Either<Failure, LoginEmailResponse>> loginUser(String email, String password) async {
    try {
      final response = await apiService.post(
        'login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final loginResponse = LoginEmailResponse.fromJson(response.data);
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
}
