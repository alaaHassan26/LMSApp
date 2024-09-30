import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../cache/cache_helper.dart';
import '../../../../core/Server/Api_Dio.dart';
import '../../../../core/Server/Error_Failures.dart';
import '../models/mcq_model.dart';
import '../models/question_model.dart';
import '../models/question_result_model.dart';

class McqRepo {
   ApiService apiService = ApiService();

  McqRepo();

Future<Either<Failure, List<QuestionResult>>> getQuestionResults(String questionId) async {
  try {
    String? token = CacheHelper().getData(key: 'saveToken') as String?;
    if (token == null) return Left(ServerFailure('Token is null'));

    // Prepare the request body
    final data = {
      'id': questionId,  // Send the ID as part of the body
    };

    // Change the request method to POST and send the body
    final response = await apiService.post(
      '/api/show_result_question', 
      data: data, 
      token: token,
    );

    print(response);
    
    if (response.statusCode == 200) {
      final List<QuestionResult> results = (response.data['result'] as List)
          .map((json) => QuestionResult.fromJson(json))
          .toList();
      print(response);
      return Right(results);
    } else {
      return Left(UnexpectedError());
    }
  } catch (e) {
    print(e);
    if (e is DioException) {
      return Left(ServerFailure.fromDioError(e));
    } else {
      print(e);
      return Left(ServerFailure(e.toString()));
    }
  }
}

 Future<Either<Failure, List<McqQuestion>>> getQuestions(String id) async {
    try {
      String? token = CacheHelper().getData(key: 'saveToken') as String?;
      if (token == null) return Left(ServerFailure('Token is null'));

      final response = await apiService.get('/api/get_question?category_id=$id', token: token);

      print(response);

      if (response.statusCode == 200) {
        final List<McqQuestion> questions = (response.data['result'] as List)
            .map((json) => McqQuestion.fromJson(json))
            .toList();

        return Right(questions);
      } else {
        return Left(UnexpectedError());
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }
  Future<Either<Failure, List<McqCategory>>> getCategories() async {
    try {
      String? token = CacheHelper().getData(key: 'saveToken') as String?;
      if (token == null) return Left(ServerFailure('Token is null'));

      final response = await apiService.get('/api/get_categories_question', token: token);

      print(response);

      if (response.statusCode == 200) {
        final List<McqCategory> categories = (response.data['result'] as List)
            .map((json) => McqCategory.fromJson(json))
            .toList();



        return Right(categories);
      } else {
        return Left(UnexpectedError());
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }
}
