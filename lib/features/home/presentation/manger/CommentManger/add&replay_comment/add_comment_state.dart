// Abstract state class

abstract class AddCommentState {
  List<Object?> get props => [];
}

class AddCommentSuccess extends AddCommentState {}

class ReplayCommentSuccess extends AddCommentState {}

class AddCommentInitial extends AddCommentState {}

class AddCommentLoading extends AddCommentState {}

class ReplayCommentLoading extends AddCommentState {}

// Failure state
class AddCommentFailure extends AddCommentState {
  final String error;

  AddCommentFailure(this.error);

  @override
  List<Object?> get props => [error];
}
