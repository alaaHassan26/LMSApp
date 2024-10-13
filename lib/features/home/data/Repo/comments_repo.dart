import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lms/cache/cache_helper.dart';
import '../../../../core/Server/Api_Dio.dart';
import '../../../../core/Server/Error_Failures.dart';
import '../model/news_comments_model.dart';

class CommentsRepo {
  final ApiService apiService = ApiService();
  // Fetch comments for a news item
  Future<Either<Failure, List<NewsCommentModel>>> getComments(String newsId) async {
    try {
      String? token = CacheHelper().getData(key: 'saveToken');
      if (token == null) return Left(ServerFailure('Token is null'));

      final response = await apiService.get('/api/get_user_comments?news_id=$newsId', token: token);

      if (response.statusCode == 200) {
        final List<NewsCommentModel> commentsList = (response.data['result'] as List)
            .map((commentJson) => NewsCommentModel.fromJson(commentJson))
            .toList();

        return Right(commentsList);
      } else {
        return Left(ServerFailure('Failed to fetch comments'));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  // Add a new comment
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

  // Add a reply to a comment
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

  // Delete a comment
  Future<Either<Failure, void>> deleteComment(String commentId) async {
    try {
      final String? token = CacheHelper().getData(key: 'saveToken');
      if (token == null) return Left(ServerFailure('Token is null'));

      final response = await apiService.delete(
        '/api/delete_comment',
        data: jsonEncode({'comment_id': commentId}),
        token: token,
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to delete comment'));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  // Edit a comment
  Future<Either<Failure, NewsCommentModel>> editComment(String commentId, String content) async {
    try {
      final String? token = CacheHelper().getData(key: 'saveToken');
      if (token == null) return Left(ServerFailure('Token is null'));

      final payload = {
        'id': commentId,
        'content': content,
      };

      final response = await apiService.put(
        '/api/edit_comment',
        data: jsonEncode(payload),
        token: token,
      );

      if (response.statusCode == 200) {
        final editedComment = NewsCommentModel.fromJson(response.data['result']);
        return Right(editedComment);
      } else {
        return Left(ServerFailure('Failed to edit comment'));
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