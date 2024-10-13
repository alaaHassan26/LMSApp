
// Abstract state class
import '../../../data/model/news_comments_model.dart';

abstract class NewsCommentState {
  List<Object?> get props => [];
}

// Initial state
class NewsCommentInitial extends NewsCommentState {}

// Loading state
class NewsCommentLoading extends NewsCommentState {}

// Success state for fetching comments
class NewsCommentFetchSuccess extends NewsCommentState {
  final List<NewsCommentModel> comments;
  
  NewsCommentFetchSuccess(this.comments);

  @override
  List<Object?> get props => [comments];
}

// Success state for adding, removing, and editing
class NewsCommentActionSuccess extends NewsCommentState {
  final String message;
  
  NewsCommentActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Failure state
class NewsCommentFailure extends NewsCommentState {
  final String error;

  NewsCommentFailure(this.error);

  @override
  List<Object?> get props => [error];
}
