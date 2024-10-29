part of 'courses_cubit_cubit.dart';

@immutable
sealed class CoursesCubitState {}

final class CoursesCubitInitial extends CoursesCubitState {}

class CoursesLoading extends CoursesCubitState {}

class CoursesSkipLoading extends CoursesCubitState {}

class CoursesLoaded extends CoursesCubitState {
  final List<Course> courses;

  CoursesLoaded(
    this.courses,
  );
}

class CoursesError extends CoursesCubitState {
  final String error;

  CoursesError(this.error);
}

class CoursesSkipError extends CoursesCubitState {
  final String error;

  CoursesSkipError(this.error);
}
