import '../../../data/models/courses_model.dart';

abstract class CoursesState {
  const CoursesState();

  List<Object> get props => [];
}

class CoursesInitial extends CoursesState {

}

class CoursesLoading extends CoursesState {

}

class CoursesLoaded extends CoursesState {
  final List<Course> courses;

  const CoursesLoaded(this.courses);

  @override
  List<Object> get props => [courses];
}

class CoursesError extends CoursesState {
  final String message;

  const CoursesError(this.message);

  @override
  List<Object> get props => [message];
}
