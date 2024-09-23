import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lms/cache/cache_helper.dart';
import '../../../../core/Server/Api_Dio.dart';
import '../../../../core/Server/Error_Failures.dart';
import '../model/news_comments_model.dart';
import '../model/news_model.dart';

class NewsRepository {
  final ApiService apiService = ApiService();

  Future<Either<Failure, List<NewsModel>>> getNews() async {
    try {
      String? token = CacheHelper().getData(key: 'saveToken');
      if (token == null) return Left(ServerFailure('Token is null'));

      // Fetch data from API
      final response = await apiService.get('/api/get_news', token: token);

      if (response.statusCode == 200) {
        final List<NewsModel> newsList = (response.data['result'] as List)
            .map((newsJson) => NewsModel.fromJson(newsJson))
            .toList();

        // Save new data to cache
        await CacheHelper().saveData(
          key: 'cached_news',
          value: jsonEncode(newsList.map((e) => e.toJson()).toList()),
        );
        print('News data cached successfully');
        return Right(newsList);
      } else {
        return Left(ServerFailure('Failed to fetch news'));
      }
    } catch (e) {
      // Handle the error and attempt to use cached data
      print('Error occurred: $e');
      final cachedData = CacheHelper().getData(key: 'cached_news');
      if (cachedData != null) {
        print('Using cached news due to error');
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

Future<Either<Failure, List<NewsCommentModel>>> getComments(String newsId) async {
  try {
    String? token = CacheHelper().getData(key: 'saveToken') as String?;
    if (token == null) return Left(ServerFailure('Token is null'));

    // Fetch data from API
    final response = await apiService.get('/api/get_user_comments?news_id=$newsId', token: token);

    if (response.statusCode == 200) {

      print(response);
      final List<NewsCommentModel> commentsList = (response.data['result'] as List)
          .map((commentJson) => NewsCommentModel.fromJson(commentJson))
          .toList();

      return Right(commentsList);
    } else {
      return Left(ServerFailure('Failed to fetch comments'));
    }
  } catch (e) {
    print('Error occurred: $e');

    // Handle the error without falling back to cached data
    if (e is DioException) {
      return Left(ServerFailure.fromDioError(e));
    } else {
      return Left(ServerFailure(e.toString()));
    }
  }
}


  Future<Either<Failure, NewsCommentModel>> addComment(String newsId, String content) async {
    try {
      final String? token = CacheHelper().getData(key: 'saveToken');
      if (token == null) return Left(ServerFailure('Token is null'));

      final payload = {
        'content': content,
        'news_id': newsId,
      };

      final response = await apiService.post(
        '/api/add_comment',
        data: jsonEncode(payload),
        token: token,
      );

      if (response.statusCode == 200) {
        final newsComment = NewsCommentModel.fromJson(response.data['result']);
        return Right(newsComment);
      } else {
        return Left(ServerFailure('Failed to add comment'));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  Future<Either<Failure, NewsCommentModel>> addReplay(String newsId, String content, String parentCommentId) async {
    try {
      final String? token = CacheHelper().getData(key: 'saveToken');
      if (token == null) return Left(ServerFailure('Token is null'));

      final payload = {
        'content': content,
        'news_id': newsId,
        'parent_comment_id': parentCommentId,
      };

      final response = await apiService.post(
        '/api/reply_comment',
        data: jsonEncode(payload),
        token: token,
      );

      if (response.statusCode == 200) {
        final newsComment = NewsCommentModel.fromJson(response.data['result']);
        return Right(newsComment);
      } else {
        return Left(ServerFailure('Failed to add reply'));
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
