import '../../../data/models/mcq_model.dart';
import '../../../data/models/question_model.dart';

abstract class McqState {}

class McqInitial extends McqState {}

class McqLoading extends McqState {}

class McqSuccess extends McqState {
  final List<McqCategory> categories;
  final List<QuestionModel>? questions; // Added optional questions list

  McqSuccess(this.categories, {this.questions});
}
class McqFailure extends McqState {
  final String errorMessage;

  McqFailure(this.errorMessage);
}
