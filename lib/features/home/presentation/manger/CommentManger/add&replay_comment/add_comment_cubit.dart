import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/Server/Error_Failures.dart';
import '../../../../domain/repo/comments_repo.dart';
import '../../../../data/model/news_comments_model.dart';
import 'add_comment_state.dart';

class AddCommentCubit extends Cubit<AddCommentState> {
  CommentsRepo commentRepository = CommentsRepo();

  AddCommentCubit() : super(AddCommentInitial());

  Future<void> addComment(String newsId, String content) async {
    emit(AddCommentLoading());
    final Either<Failure, NewsCommentModel> result =
        await commentRepository.addComment(newsId, content);

    result.fold(
      (failure) => emit(AddCommentFailure(failure.err)),
      (comment) => emit(AddCommentSuccess()),
    );
  }

  Future<void> addReply(
      String newsId, String content, String parentCommentId) async {
    emit(AddCommentLoading());
    final Either<Failure, NewsCommentModel?> result =
        await commentRepository.addReplay(newsId, content, parentCommentId);

    result.fold(
      (failure) => emit(AddCommentFailure(failure.err)),
      (comment) => emit(AddCommentSuccess()),
    );
  }
}
