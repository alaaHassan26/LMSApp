
// Abstract state class

abstract class EditCommentState {
  List<Object?> get props => [];
}


class EditCommentSuccess extends EditCommentState {}
class ReplayCommentSuccess extends EditCommentState {}
class EditCommentInitial extends EditCommentState {}
class EditCommentLoading extends EditCommentState {}
class ReplayCommentLoading extends EditCommentState {}

// Failure state
class EditCommentFailure extends EditCommentState {
  final String error;

  EditCommentFailure(this.error);

  @override
  List<Object?> get props => [error];
}
