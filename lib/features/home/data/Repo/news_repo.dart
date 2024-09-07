import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lms/cache/cache_helper.dart';

import '../../../../core/Server/Api_Dio.dart';
import '../../../../core/Server/Error_Failures.dart';
import '../model/news_model.dart';

class NewsRepository {
   ApiService apiService = ApiService();

  NewsRepository();

  Future<Either<Failure, List<NewsModel>>> getNews() async {
    try {

          String? token = CacheHelper().getData(key: 'saveToken');

      final response = await apiService.get('/api/get_news' , token:token! );

      print('Response data: ${response.data} + $token');

      final List<NewsModel> newsList = (response.data['result'] as List)
          .map((newsJson) => NewsModel.fromJson(newsJson))
          .toList();

      return Right(newsList);
    } catch (e) {
      if (e is DioException) {
        print('DioError: ${e.message}');
        print('DioError Response: ${e.response?.data}');
        print('DioError Type: ${e.type}');
        return Left(ServerFailure.fromDioError(e));
      }

      print('General Error: ${e.toString()}');
      return Left(ServerFailure(e.toString()));
    }
  }
}
