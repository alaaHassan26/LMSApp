import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lms/core/Server/Error_Failures.dart';
import 'package:lms/features/home/data/data_sources/comments/comments_remot_data_source.dart';
import 'package:lms/features/home/data/model/news_comments_model.dart';

abstract class CommentsRepo {
  Future<Either<Failure, List<NewsCommentModel>>> getComments(
      {int skip = 0, required String newsId});
}

class CommentsRepoImpl extends CommentsRepo {
  final CommentsRemotDataSource commentsRemotDataSource;

  CommentsRepoImpl({required this.commentsRemotDataSource});

  @override
  Future<Either<Failure, List<NewsCommentModel>>> getComments(
      {int skip = 0, required String newsId}) async {
    try {
      List<NewsCommentModel> remoteComments =
          await commentsRemotDataSource.getComments(newsId: newsId, skip: skip);

      return right(remoteComments);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
