import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/Server/Error_Failures.dart';
import '../../../data/Repo/Courese_Repo.dart';
import '../../../data/models/courses_model.dart';
import 'course_state.dart';



class CoursesCubit extends Cubit<CoursesState> {
  final CoursesRepository coursesRepository = CoursesRepository();
  List<Course> allCourses = [];
  int skip = 0;
  final int limit = 10;
  bool hasMoreCourses = true;

  CoursesCubit() : super(CoursesInitial());

  Future<void> fetchCourses() async {
    if (!hasMoreCourses) return;

    emit(CoursesLoading());
    final Either<Failure, List<Course>> result = await coursesRepository.getCourses(skip: skip, limit: limit);

    result.fold(
      (failure) {
        emit(CoursesError(failure.err));
      },
      (courses) {
        if (courses.isEmpty) {
          hasMoreCourses = false; 
        } else {
          allCourses.addAll(courses);
          skip += limit; 
        }
        emit(CoursesLoaded(allCourses, hasMoreCourses: hasMoreCourses));
      },
    );
  }

  void resetCourses() {
    allCourses.clear();
    skip = 0;
    hasMoreCourses = true;
    emit(CoursesInitial());
  }
}