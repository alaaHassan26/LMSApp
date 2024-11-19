// Abstract state class

abstract class DeleteCommentState {
  List<Object?> get props => [];
}

class DeleteCommentSuccess extends DeleteCommentState {}

class DeleteCommentInitial extends DeleteCommentState {}

class DeleteCommentLoading extends DeleteCommentState {}

// Failure state
class DeleteCommentFailure extends DeleteCommentState {
  final String error;

  DeleteCommentFailure(this.error);

  @override
  List<Object?> get props => [error];
}
