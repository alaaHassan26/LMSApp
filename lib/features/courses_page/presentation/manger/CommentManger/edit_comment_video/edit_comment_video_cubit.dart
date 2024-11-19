import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:lms/features/courses_page/domain/repo/comments_video_repo.dart';
import 'package:lms/features/home/data/model/news_comments_model.dart';

import '../../../../../../core/Server/Error_Failures.dart';

import 'edit_comment_video_state.dart';

class EditCommentVideoCubit extends Cubit<EditCommentVideoState> {
  CommentsVideoRepo commentRepository = CommentsVideoRepo();

  EditCommentVideoCubit() : super(EditCommentVideoInitial());

  Future<void> editComment(String videoId, String content) async {
    emit(EditCommentVideoLoading());
    final Either<Failure, NewsCommentModel> result =
        await commentRepository.editCommentVideo(videoId, content);

    result.fold(
      (failure) => emit(EditCommentVideoFailure(failure.err)),
      (comment) => emit(EditCommentVideoSuccess()),
    );
  }
}
