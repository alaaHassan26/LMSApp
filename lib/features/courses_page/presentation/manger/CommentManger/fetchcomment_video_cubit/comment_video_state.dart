// Abstract state class

import 'package:lms/features/home/data/model/news_comments_model.dart';

abstract class VideoCommentState {
  List<Object?> get props => [];
}

class VideoCommentInitial extends VideoCommentState {}

class VideoCommentLoading extends VideoCommentState {}

class VideoCommentEmpty extends VideoCommentState {}

class VideoCommentFetchSuccess extends VideoCommentState {
  final List<NewsCommentModel> comments;

  VideoCommentFetchSuccess(this.comments);

  @override
  List<Object?> get props => [comments];
}

class VideoCommentActionSuccess extends VideoCommentState {
  final String message;

  VideoCommentActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class VideoCommentFailure extends VideoCommentState {
  final String error;

  VideoCommentFailure(this.error);

  @override
  List<Object?> get props => [error];
}
