import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lms/cache/cache_helper.dart';
import '../../../../core/Server/Api_Dio.dart';
import '../../../../core/Server/Error_Failures.dart';
import '../model/news_model.dart';

class NewsRepository {
  final ApiService apiService = ApiService();

  // Fetch news
  Future<Either<Failure, List<NewsModel>>> getNews({required int skip, required int limit}) async {
    try {
      String? token = CacheHelper().getData(key: 'saveToken');
      if (token == null) return Left(ServerFailure('Token is null'));

      final response = await apiService.get('/api/get_news?skip=$skip&limit=$limit', token: token);

      if (response.statusCode == 200) {
        final List<NewsModel> newsList = (response.data['result'] as List)
            .map((newsJson) => NewsModel.fromJson(newsJson))
            .toList();

        await CacheHelper().saveData(
          key: 'cached_news',
          value: jsonEncode(newsList.map((e) => e.toJson()).toList()),
        );

        return Right(newsList);
      } else {
        return Left(ServerFailure('Failed to fetch news'));
      }
    } catch (e) {
      final cachedData = CacheHelper().getData(key: 'cached_news');
      if (cachedData != null) {
        final List<NewsModel> cachedNewsList = (jsonDecode(cachedData) as List)
            .map((newsJson) => NewsModel.fromJson(newsJson))
            .toList();
        return Right(cachedNewsList);
      }

      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

}
