import 'package:dartz/dartz.dart';
import 'package:lms/core/Server/Error_Failures.dart';
import 'package:lms/features/courses_page/data/models/mcq_model.dart';
import 'package:lms/features/courses_page/data/models/question_model.dart';
import 'package:lms/features/courses_page/data/models/question_result_model.dart';
import 'package:lms/features/courses_page/domain/repo/mcq_repo.dart';

class FetchMcqUseCase {
  final McqRepo mcqRepo;

  FetchMcqUseCase({required this.mcqRepo});
  Future<Either<Failure, List<QuestionResult>>> getQuestionResults(
      {required String questionId}) {
    return mcqRepo.getQuestionResults(questionId: questionId);
  }

  Future<Either<Failure, List<McqQuestion>>> getQuestions(
      {required String id}) {
    return mcqRepo.getQuestions(id: id);
  }

  Future<Either<Failure, List<McqCategory>>> getCategories() {
    return mcqRepo.getCategories();
  }
}
