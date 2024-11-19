import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lms/core/Server/Error_Failures.dart';
import 'package:lms/features/courses_page/data/data_sources/comments/comments_video_remot_data_source.dart';

import 'package:lms/features/home/data/model/news_comments_model.dart';

abstract class CommentsVideoRepo {
  Future<Either<Failure, List<NewsCommentModel>>> getCommentsVideo(
      {int skip = 0, required String videoId});
}

class CommentsVideoRepoImpl extends CommentsVideoRepo {
  final CommentsVideoRemotDataSource commentsRemotDataSource;

  CommentsVideoRepoImpl({required this.commentsRemotDataSource});

  @override
  Future<Either<Failure, List<NewsCommentModel>>> getCommentsVideo(
      {int skip = 0, required String videoId}) async {
    try {
      List<NewsCommentModel> remoteCommentsVideo = await commentsRemotDataSource
          .getCommentsVideo(videoId: videoId, skip: skip);

      return right(remoteCommentsVideo);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
