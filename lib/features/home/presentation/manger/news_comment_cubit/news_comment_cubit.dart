import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/Repo/news_repo.dart';
import 'news_comment_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
   NewsRepository newsRepository = NewsRepository(); 

  CommentsCubit() : super(CommentsInitial());

  Future<void> fetchComments(String newsId) async {
    emit(CommentsLoading());
    final eitherResponse = await newsRepository.getComments(newsId);

    eitherResponse.fold(
      (failure) => emit(CommentsError(failure.err)),
      (commentsList) => emit(CommentsLoaded(commentsList)),
    );
  }

  Future<void> addComment(String newsId, String content) async {
    emit(CommentsLoading());
    final eitherResponse = await newsRepository.addComment(newsId, content);

    eitherResponse.fold(
      (failure) => emit(CommentsError(failure.err)),
      (_) {
        fetchComments(newsId);
        emit(CommentAdded());
      },
    );
  }

  Future<void> replayComment(String newsId, String content, String parentCommentId) async {
    emit(CommentsLoading());
    final eitherResponse = await newsRepository.addReplay(newsId, content, parentCommentId);

    eitherResponse.fold(
      (failure) => emit(CommentsError(failure.err)),
      (_) {
        fetchComments(newsId);
        emit(CommentReplied());
      },
    );
  }
}
