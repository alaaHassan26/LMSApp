import 'package:bloc/bloc.dart';
import 'package:lms/features/courses_page/data/models/mcq_model.dart';
import 'package:lms/features/courses_page/domain/use_case_courses/use_case_mcq.dart';

import 'mcq_state.dart';

class McqCubit extends Cubit<McqState> {
  final FetchMcqUseCase fetchMcqUseCase;
  McqCubit(this.fetchMcqUseCase) : super(McqInitial());
  Future<void> getQuestionResults({required String questionId}) async {
    emit(McqResultLoading());
    var ruslt =
        await fetchMcqUseCase.getQuestionResults(questionId: questionId);
    ruslt.fold((failure) {
      emit(McqFailure(failure.err));
    }, (result) {
      emit(McqResultSuccess(result));
    });
  }

  Future<void> getQuestions({required String id}) async {
    emit(McqLoading());
    var ruslt = await fetchMcqUseCase.getQuestions(id: id);
    ruslt.fold((failure) {
      emit(McqFailure(failure.err));
    }, (questions) {
      final List<McqCategory> categories = [];
      emit(McqSuccess(categories, questions: questions));
    });
  }

  Future<void> getCategories() async {
    emit(McqLoading());
    var ruslt = await fetchMcqUseCase.getCategories();
    ruslt.fold((failure) {
      emit(McqFailure(failure.err));
    }, (categor) {
      emit(McqSuccess(categor));
    });
  }
}
