import '../../../data/models/lessons_model.dart';

abstract class LessonsState {
  const LessonsState();

  List<Object> get props => [];
}

class LessonsInitial extends LessonsState {
  const LessonsInitial();

  @override
  List<Object> get props => []; 
}

class LessonsLoading extends LessonsState {
  const LessonsLoading();

  @override
  List<Object> get props => []; 
}
class NoLessons extends LessonsState {
  const NoLessons();

  @override
  List<Object> get props => []; 
}

class LessonsLoaded extends LessonsState {
  final List<Lesson> lessons;

  const LessonsLoaded(this.lessons);

  @override
  List<Object> get props => [lessons];
}

class LessonsError extends LessonsState {
  final String message;

  const LessonsError(this.message);

  @override
  List<Object> get props => [message];
}
