import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lms/features/courses_page/domain/use_case_courses/use_case_lesson.dart';

import 'lessons_state.dart';

class LessonsCubit extends Cubit<LessonsState> {
  final FetchLessonUseCase fetchLessonUseCase;
  LessonsCubit(this.fetchLessonUseCase) : super(const LessonsInitial());
  Future<void> fetchLesson({required String categoryId}) async {
    emit(const LessonsLoading());
    var ruslt = await fetchLessonUseCase.lesson(categoryId: categoryId);
    ruslt.fold((failure) {
      emit(LessonsError(failure.err));
    }, (lesson) {
      emit(LessonsLoaded(lesson));
    });
  }
}
