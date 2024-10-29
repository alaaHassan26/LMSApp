import 'package:dartz/dartz.dart';
import 'package:lms/core/Server/Error_Failures.dart';
import 'package:lms/features/courses_page/data/models/mcq_model.dart';
import 'package:lms/features/courses_page/data/models/question_model.dart';
import 'package:lms/features/courses_page/data/models/question_result_model.dart';

abstract class McqRepo {
  Future<Either<Failure, List<QuestionResult>>> getQuestionResults(
      {required String questionId});
  Future<Either<Failure, List<McqQuestion>>> getQuestions({required String id});
  Future<Either<Failure, List<McqCategory>>> getCategories();
}
