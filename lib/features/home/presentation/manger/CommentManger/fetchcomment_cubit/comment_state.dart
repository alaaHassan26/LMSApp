// Abstract state class
import '../../../../data/model/news_comments_model.dart';

abstract class NewsCommentState {
  List<Object?> get props => [];
}

class NewsCommentInitial extends NewsCommentState {}

class NewsCommentLoading extends NewsCommentState {}

class NewsCommentEmpty extends NewsCommentState {}

class NewsCommentFetchSuccess extends NewsCommentState {
  final List<NewsCommentModel> comments;

  NewsCommentFetchSuccess(this.comments);

  @override
  List<Object?> get props => [comments];
}

class NewsCommentActionSuccess extends NewsCommentState {
  final String message;

  NewsCommentActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class NewsCommentFailure extends NewsCommentState {
  final String error;

  NewsCommentFailure(this.error);

  @override
  List<Object?> get props => [error];
}
