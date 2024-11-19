// Abstract state class

abstract class AddCommentVideoState {
  List<Object?> get props => [];
}

class AddCommentVideoSuccess extends AddCommentVideoState {}

class ReplayCommentViseoSuccess extends AddCommentVideoState {}

class AddCommentVideoInitial extends AddCommentVideoState {}

class AddCommentVideoLoading extends AddCommentVideoState {}

class ReplayCommentVideoLoading extends AddCommentVideoState {}

// Failure state
class AddCommentVideoFailure extends AddCommentVideoState {
  final String error;

  AddCommentVideoFailure(this.error);

  @override
  List<Object?> get props => [error];
}
