import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/Server/Error_Failures.dart';
import '../../../../domain/repo/comments_repo.dart';
import '../../../../data/model/news_comments_model.dart';
import 'edit_comment_state.dart';

class EditCommentCubit extends Cubit<EditCommentState> {
  CommentsRepo commentRepository = CommentsRepo();

  EditCommentCubit() : super(EditCommentInitial());

  Future<void> editComment(String newsId, String content) async {
    emit(EditCommentLoading());
    final Either<Failure, NewsCommentModel> result =
        await commentRepository.editComment(newsId, content);

    result.fold(
      (failure) => emit(EditCommentFailure(failure.err)),
      (comment) => emit(EditCommentSuccess()),
    );
  }
}
