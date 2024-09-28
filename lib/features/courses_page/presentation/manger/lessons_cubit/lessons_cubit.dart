import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/Server/Error_Failures.dart';
import '../../../data/Repo/Courese_Repo.dart';
import '../../../data/models/lessons_model.dart';
import 'lessons_state.dart';


class LessonsCubit extends Cubit<LessonsState> {
   CoursesRepository coursesRepository = CoursesRepository();

  LessonsCubit() : super(const LessonsInitial());

  Future<void> fetchLessons(String categoryId) async {
    emit(const LessonsLoading());
    final Either<Failure, List<Lesson>> result = await coursesRepository.getLessons(categoryId);
    result.fold(
      (failure) => emit(LessonsError(failure.err)),
      (lessons) => emit(LessonsLoaded(lessons)),
    );
  }
}
