// Abstract state class

abstract class DeleteCommentVideoState {
  List<Object?> get props => [];
}

class DeleteCommentVideoSuccess extends DeleteCommentVideoState {}

class DeleteCommentVideoInitial extends DeleteCommentVideoState {}

class DeleteCommentVideoLoading extends DeleteCommentVideoState {}

// Failure state
class DeleteCommentVideoFailure extends DeleteCommentVideoState {
  final String error;

  DeleteCommentVideoFailure(this.error);

  @override
  List<Object?> get props => [error];
}
