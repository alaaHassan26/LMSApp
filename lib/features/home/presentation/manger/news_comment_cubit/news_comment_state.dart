import '../../../data/model/news_comments_model.dart';

abstract class CommentsState {
  List<Object> get props => [];
}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}
class CommentReplied extends CommentsState {}
class CommentsAdding extends CommentsState {}


class CommentAdded extends CommentsState {}
class CommentsLoaded extends CommentsState {
  final List<NewsCommentModel> commentsList;
  CommentsLoaded(this.commentsList);
}
class CommentsError extends CommentsState {
  final String message;

  CommentsError(this.message);

  @override
  List<Object> get props => [message];
}
