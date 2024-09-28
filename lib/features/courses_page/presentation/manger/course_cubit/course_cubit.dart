import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/Server/Error_Failures.dart';
import '../../../data/Repo/Courese_Repo.dart';
import '../../../data/models/courses_model.dart';
import 'course_state.dart';



class CoursesCubit extends Cubit<CoursesState> {
   CoursesRepository coursesRepository = CoursesRepository();

  CoursesCubit() : super(CoursesInitial());


  Future<void> fetchCourses() async {
    emit(CoursesLoading());
    final Either<Failure, List<Course>> result = await coursesRepository.getCourses();

    result.fold(
      (failure) => emit(CoursesError(failure.err)),
      (courses) => emit(CoursesLoaded(courses)),
    );
  }
}
