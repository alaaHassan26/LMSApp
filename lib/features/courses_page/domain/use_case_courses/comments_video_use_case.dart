import 'package:dartz/dartz.dart';
import 'package:lms/core/Server/Error_Failures.dart';
import 'package:lms/features/courses_page/data/repo_impl/comments_video_repo.dart';
import 'package:lms/features/home/data/model/news_comments_model.dart';

class FetchCommentsVideoUseCase {
  final CommentsVideoRepo commentsVideoRepo;

  FetchCommentsVideoUseCase(this.commentsVideoRepo);
  Future<Either<Failure, List<NewsCommentModel>>> call(
      {int skip = 0, required String videoId}) {
    return commentsVideoRepo.getCommentsVideo(videoId: videoId, skip: skip);
  }
}
