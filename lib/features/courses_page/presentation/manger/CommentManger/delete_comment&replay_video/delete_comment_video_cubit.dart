import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:lms/features/courses_page/domain/repo/comments_video_repo.dart';

import '../../../../../../core/Server/Error_Failures.dart';

import 'delete_comment_video_state.dart';

class DeleteCommentVideoCubit extends Cubit<DeleteCommentVideoState> {
  CommentsVideoRepo commentRepository = CommentsVideoRepo();

  DeleteCommentVideoCubit() : super(DeleteCommentVideoInitial());

  Future<void> deleteComment(String commentId) async {
    emit(DeleteCommentVideoLoading());
    final Either<Failure, void> result =
        await commentRepository.deleteCommentVideo(commentId);

    result.fold(
      (failure) => emit(DeleteCommentVideoFailure(failure.err)),
      (comment) => emit(DeleteCommentVideoSuccess()),
    );
  }

  Future<void> deleteReplay(String commentId) async {
    emit(DeleteCommentVideoLoading());
    final Either<Failure, void> result =
        await commentRepository.deleteReplayVideo(commentId);

    result.fold(
      (failure) => emit(DeleteCommentVideoFailure(failure.err)),
      (comment) => emit(DeleteCommentVideoSuccess()),
    );
  }
}
