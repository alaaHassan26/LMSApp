import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:lms/features/courses_page/domain/repo/comments_video_repo.dart';
import 'package:lms/features/courses_page/presentation/manger/CommentManger/add&replay_comment_video/add_comment_video_state.dart';
import 'package:lms/features/home/data/model/news_comments_model.dart';

import '../../../../../../core/Server/Error_Failures.dart';

class AddCommentVideoCubit extends Cubit<AddCommentVideoState> {
  CommentsVideoRepo commentRepository = CommentsVideoRepo();

  AddCommentVideoCubit() : super(AddCommentVideoInitial());

  Future<void> addComment(String videoId, String content) async {
    emit(AddCommentVideoLoading());
    final Either<Failure, NewsCommentModel> result =
        await commentRepository.addCommentVideo(videoId, content);

    result.fold(
      (failure) => emit(AddCommentVideoFailure(failure.err)),
      (comment) => emit(AddCommentVideoSuccess()),
    );
  }

  Future<void> addReply(
      String newsId, String content, String parentCommentId) async {
    emit(AddCommentVideoLoading());
    final Either<Failure, NewsCommentModel?> result = await commentRepository
        .addReplayVideo(newsId, content, parentCommentId);

    result.fold(
      (failure) => emit(AddCommentVideoFailure(failure.err)),
      (comment) => emit(AddCommentVideoSuccess()),
    );
  }
}
