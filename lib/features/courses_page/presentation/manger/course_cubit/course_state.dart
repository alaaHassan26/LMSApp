import '../../../data/models/courses_model.dart';
abstract class CoursesState {}

class CoursesInitial extends CoursesState {}

class CoursesLoading extends CoursesState {}

class CoursesLoaded extends CoursesState {
  final List<Course> courses;
  final bool hasMoreCourses;

  CoursesLoaded(this.courses, {this.hasMoreCourses = true});
}

class CoursesError extends CoursesState {
  final String error;

  CoursesError(this.error);
}