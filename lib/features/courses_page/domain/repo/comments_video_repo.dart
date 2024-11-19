import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lms/cache/cache_helper.dart';
import 'package:lms/features/home/data/model/news_comments_model.dart';
import '../../../../core/Server/Api_Dio.dart';
import '../../../../core/Server/Error_Failures.dart';

class CommentsVideoRepo {
  final ApiService apiService = ApiService();
  // Fetch comments for a news item
  Future<Either<Failure, List<NewsCommentModel>>> getCommentsVideo(
      String newsId) async {
    try {
      String? token = CacheHelper().getData(key: 'saveToken');
      if (token == null) return Left(ServerFailure('Token is null'));

      final response = await apiService.get(
          '/api/get_user_lessons_comments?lessons_id=$newsId',
          token: token);

      if (response.statusCode == 200) {
        final List<NewsCommentModel> commentsList =
            (response.data['result'] as List)
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
  Future<Either<Failure, NewsCommentModel>> addCommentVideo(
      String newsId, String content) async {
    try {
      final String? token = CacheHelper().getData(key: 'saveToken');
      if (token == null) return Left(ServerFailure('Token is null'));

      final payload = {
        'content': content,
        'news_id': newsId,
      };

      final response = await apiService.post(
        '/api/add_lessons_comment',
        data: jsonEncode(payload),
        token: token,
      );

      print(response); // For debugging purposes

      if (response.statusCode == 200) {
        // Handle the result as a list
        final resultList = response.data['result'] as List;

        if (resultList.isNotEmpty) {
          // Access the first item in the list to create the NewsCommentModel
          final newsComment = NewsCommentModel.fromJson(resultList[0]);
          return Right(newsComment);
        } else {
          return Left(ServerFailure('No comment added'));
        }
      } else {
        return Left(ServerFailure('Failed to add comment'));
      }
    } catch (e) {
      print(e); // For debugging purposes
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

// Add a reply to a comment
  Future<Either<Failure, NewsCommentModel?>> addReplayVideo(
      String newsId, String content, String parentCommentId) async {
    try {
      final String? token = CacheHelper().getData(key: 'saveToken');
      if (token == null) {
        return Left(ServerFailure('Token is null'));
      }

      final payload = {
        'content': content,
        'news_id': newsId,
        'parent_comment_id': parentCommentId,
      };

      // Make the API request to add a reply
      final response = await apiService.post(
        '/api/reply_lessons_comment',
        data: jsonEncode(payload),
        token: token,
      );

      // Check for successful response
      if (response.statusCode == 200) {
        // Check if the response data is a list
        if (response.data['result'] is List) {
          // If the API returns a list, handle it accordingly
          final replies = (response.data['result'] as List)
              .map((item) => NewsCommentModel.fromJson(item))
              .toList();

          // Return the first comment if available, or null
          return Right(replies.isNotEmpty ? replies.first : null);
        }

        // If it's not a list, process as a single object
        final newsComment = NewsCommentModel.fromJson(response.data['result']);
        return Right(newsComment);
      } else {
        // Handle unsuccessful status codes
        return Left(ServerFailure(
            'Failed to add reply: ${response.statusCode} ${response.statusMessage}'));
      }
    } catch (e) {
      // Print the error for debugging purposes
      print('Error occurred while adding reply: $e');

      // Handle Dio exceptions specifically
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      } else {
        // Handle other types of exceptions
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  // Delete a comment
  Future<Either<Failure, void>> deleteCommentVideo(String commentId) async {
    try {
      final String? token = CacheHelper().getData(key: 'saveToken');
      if (token == null) return Left(ServerFailure('Token is null'));

      final response = await apiService.delete(
        '/api/delete_lessons_comment',
        data: jsonEncode({'comment_id': commentId}),
        token: token,
      );
      print(response);
      print(response);
      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to delete comment'));
      }
    } catch (e) {
      print(e);

      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  Future<Either<Failure, void>> deleteReplayVideo(String commentId) async {
    try {
      final String? token = CacheHelper().getData(key: 'saveToken');
      if (token == null) return Left(ServerFailure('Token is null'));

      final response = await apiService.delete(
        '/api/delete_reply_lessons_comment',
        data: jsonEncode({'comment_id': commentId}),
        token: token,
      );
      print(response);
      print(response);
      if (response.statusCode == 200) {
        print('deleted replay');
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to delete comment'));
      }
    } catch (e) {
      print(e);

      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

// Edit a comment
  Future<Either<Failure, NewsCommentModel>> editCommentVideo(
      String commentId, String content) async {
    try {
      final String? token = CacheHelper().getData(key: 'saveToken');
      if (token == null) return Left(ServerFailure('Token is null'));

      final payload = {
        'id': commentId,
        'content': content,
      };

      final response = await apiService.put(
        '/api/edit_lessons_comment',
        data: jsonEncode(payload),
        token: token,
      );
      print(response);

      if (response.statusCode == 200) {
        // Fix: Check if 'result' is a list and extract the first element
        final List<dynamic> result = response.data['result'];
        if (result.isNotEmpty) {
          final editedComment = NewsCommentModel.fromJson(result[0]);
          return Right(editedComment);
        } else {
          return Left(ServerFailure('No comment returned'));
        }
      } else {
        return Left(ServerFailure('Failed to edit comment'));
      }
    } catch (e) {
      print(e);

      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }
}
