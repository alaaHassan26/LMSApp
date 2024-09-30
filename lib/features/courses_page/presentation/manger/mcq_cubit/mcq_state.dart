import '../../../data/models/mcq_model.dart';
import '../../../data/models/question_model.dart';
import '../../../data/models/question_result_model.dart';

abstract class McqState {}

class McqInitial extends McqState {}

class McqLoading extends McqState {}
class McqResultLoading extends McqState {}

class McqSuccess extends McqState {
  final List<McqCategory> categories;
  final List<McqQuestion>? questions;

  McqSuccess(this.categories, {this.questions});
}
class McqFailure extends McqState {
  final String errorMessage;

  McqFailure(this.errorMessage);
}
class McqResultSuccess extends McqState {
  final List<QuestionResult> results;

  McqResultSuccess(this.results);
}