import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:lms/features/courses_page/data/Repo/Mcq_Repo.dart';
import 'package:lms/features/courses_page/data/models/mcq_model.dart';
import '../../../../../core/Server/Error_Failures.dart';
import '../../../data/models/question_model.dart';
import '../../../data/models/question_result_model.dart';
import 'mcq_state.dart';

class McqCubit extends Cubit<McqState> {
   McqRepo repository = McqRepo();

  McqCubit() : super(McqInitial());

Future<void> getQuestionResults(String questionId) async {
    emit(McqResultLoading());
    final Either<Failure, List<QuestionResult>> result = await repository.getQuestionResults(questionId);

    result.fold(
      (failure) {
        emit(McqFailure(failure.err)); 
      },
      (results) {
        emit(McqResultSuccess(results)); 
      },
    );
  }

  Future<void> getQuestions(String categoryId) async {
    emit(McqLoading());
    print('Fetching questions for category: $categoryId');

    final Either<Failure, List<McqQuestion>> result = await repository.getQuestions(categoryId);

    result.fold(
      (failure) {
        print('Failed to fetch questions: ${failure.err}');
        emit(McqFailure(failure.err)); 
      },
      (questions) {
        print('Fetched ${questions.length} questions.');

        final List<McqCategory> categories = []; 

        emit(McqSuccess(categories, questions: questions)); 
      },
    );
  }


  Future<void> mcqCategories() async {
    emit(McqLoading()); 

    final Either<Failure, List<McqCategory>> result = await repository.getCategories();

    result.fold(
      (failure) {
        emit(McqFailure(failure.err)); 
      },
      (categories) {
        emit(McqSuccess(categories)); 
      },
    );
  }
}
