import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/Server/Error_Failures.dart';
import '../../../../data/Repo/comments_repo.dart';
import 'delete_comment_state.dart';


class DeleteCommentCubit extends Cubit<DeleteCommentState> {
   CommentsRepo commentRepository = CommentsRepo();

  DeleteCommentCubit() : super(DeleteCommentInitial());


    Future<void> deleteComment(String commentId) async {
    emit(DeleteCommentLoading());
    final Either<Failure, void> result = await commentRepository.deleteComment(commentId);
    
    result.fold(
      (failure) => emit(DeleteCommentFailure(failure.err)),
      (comment) => emit(DeleteCommentSuccess()),
    );
  }

      Future<void> deleteReplay(String commentId) async {
    emit(DeleteCommentLoading());
    final Either<Failure, void> result = await commentRepository.deleteReplay(commentId);
    
    result.fold(
      (failure) => emit(DeleteCommentFailure(failure.err)),
      (comment) => emit(DeleteCommentSuccess()),
    );
  }

}
