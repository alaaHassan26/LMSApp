import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:lms/features/courses_page/data/models/courses_model.dart';
import 'package:lms/features/courses_page/domain/use_case_courses/use_case_courses.dart';

part 'courses_cubit_state.dart';

class CoursesCubitCubit extends Cubit<CoursesCubitState> {
  List<Course> allCourses = [];
  bool hasReachedEnd = false;
  bool isLoadingMore = false;
  bool isInitialLoading = false;
  final FetchCoursestUseCase fetchCoursestUseCase;
  CoursesCubitCubit(this.fetchCoursestUseCase) : super(CoursesCubitInitial());
  Future<void> fetchCourses({int skip = 0}) async {
    if (hasReachedEnd || isLoadingMore) return;
    if (skip == 0) {
      isInitialLoading = true;
      emit(CoursesLoading());
    } else {
      isLoadingMore = true;
    }
    if (skip == 0) {
      emit(CoursesLoaded(allCourses));
    }
    var ruslt = await fetchCoursestUseCase.coures(skip: skip);
    ruslt.fold((failure) {
      isInitialLoading = false;
      if (skip == 0) {
        emit(CoursesError(failure.err));
      } else {
        emit(CoursesSkipError(failure.err));
      }
    }, (courses) {
      isInitialLoading = false;
      isLoadingMore = false;
      if (courses.length < 10) {
        hasReachedEnd = true;
      }
      allCourses.addAll(courses);
      emit(CoursesLoaded(allCourses));
    });
  }
}
