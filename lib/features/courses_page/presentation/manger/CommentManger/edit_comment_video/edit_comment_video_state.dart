// Abstract state class

abstract class EditCommentVideoState {
  List<Object?> get props => [];
}

class EditCommentVideoSuccess extends EditCommentVideoState {}

class ReplayCommentVideoSuccess extends EditCommentVideoState {}

class EditCommentVideoInitial extends EditCommentVideoState {}

class EditCommentVideoLoading extends EditCommentVideoState {}

class ReplayCommentLoading extends EditCommentVideoState {}

// Failure state
class EditCommentVideoFailure extends EditCommentVideoState {
  final String error;

  EditCommentVideoFailure(this.error);

  @override
  List<Object?> get props => [error];
}
