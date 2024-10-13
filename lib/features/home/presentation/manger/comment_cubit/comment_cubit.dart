import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/Server/Error_Failures.dart';
import '../../../data/Repo/comments_repo.dart';
import '../../../data/model/news_comments_model.dart';
import 'comment_state.dart';


class NewsCommentCubit extends Cubit<NewsCommentState> {
   CommentsRepo commentRepository = CommentsRepo();

  NewsCommentCubit() : super(NewsCommentInitial());

  // Fetch comments
  Future<void> fetchComments(String newsId) async {
    emit(NewsCommentLoading());
    final Either<Failure, List<NewsCommentModel>> result = await commentRepository.getComments(newsId);
    
    result.fold(
      (failure) => emit(NewsCommentFailure(failure.err)),
      (comments) => emit(NewsCommentFetchSuccess(comments)),
    );
  }

  // Add a new comment
  Future<void> addComment(String newsId, String content) async {
    emit(NewsCommentLoading());
    final Either<Failure, NewsCommentModel> result = await commentRepository.addComment(newsId, content);
    
    result.fold(
      (failure) => emit(NewsCommentFailure(failure.err)),
      (comment) => emit(NewsCommentActionSuccess("Comment added successfully")),
    );
  }

  // Add a reply to a comment
  Future<void> addReply(String newsId, String content, String parentCommentId) async {
    emit(NewsCommentLoading());
    final Either<Failure, NewsCommentModel> result = await commentRepository.addReplay(newsId, content, parentCommentId);
    
    result.fold(
      (failure) => emit(NewsCommentFailure(failure.err)),
      (comment) => emit(NewsCommentActionSuccess("Reply added successfully")),
    );
  }

  // Edit a comment
  Future<void> editComment(String commentId, String content) async {
    emit(NewsCommentLoading());
    final Either<Failure, NewsCommentModel> result = await commentRepository.editComment(commentId, content);
    
    result.fold(
      (failure) => emit(NewsCommentFailure(failure.err)),
      (editedComment) => emit(NewsCommentActionSuccess("Comment edited successfully")),
    );
  }

  // Delete a comment
  Future<void> deleteComment(String commentId) async {
    emit(NewsCommentLoading());
    final Either<Failure, void> result = await commentRepository.deleteComment(commentId);
    
    result.fold(
      (failure) => emit(NewsCommentFailure(failure.err)),
      (_) => emit(NewsCommentActionSuccess("Comment deleted successfully")),
    );
  }
}
