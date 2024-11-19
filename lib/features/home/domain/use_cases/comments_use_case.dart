import 'package:dartz/dartz.dart';
import 'package:lms/core/Server/Error_Failures.dart';
import 'package:lms/features/home/data/model/news_comments_model.dart';
import 'package:lms/features/home/data/repos_impl/comments_repo.dart';

class FetchCommentstUseCase {
  final CommentsRepo commentsRepo;

  FetchCommentstUseCase(this.commentsRepo);
  Future<Either<Failure, List<NewsCommentModel>>> call(
      {int skip = 0, required String newsId}) {
    return commentsRepo.getComments(newsId: newsId, skip: skip);
  }
}
