import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/Server/Error_Failures.dart';
import '../../../../domain/repo/comments_repo.dart';
import '../../../../data/model/news_comments_model.dart';
import 'comment_state.dart';

class NewsCommentCubit extends Cubit<NewsCommentState> {
  CommentsRepo commentRepository = CommentsRepo();

  NewsCommentCubit() : super(NewsCommentInitial());

  // Fetch comments
  Future<void> fetchComments(String newsId) async {
    emit(NewsCommentLoading());

    final Either<Failure, List<NewsCommentModel>> result =
        await commentRepository.getComments(newsId);

    result.fold(
      (failure) {
        emit(NewsCommentFailure(failure.err));
      },
      (comments) {
        if (comments.isEmpty) {
          emit(NewsCommentEmpty());
        } else {
          emit(NewsCommentFetchSuccess(comments));
        }
      },
    );
  }
}
