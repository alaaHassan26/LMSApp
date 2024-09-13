class QuestionModel {
  final String questionText;
  final List<String> answers;
  final List<int> correctAnswerIndices;
  final String explanation;
  final bool isMultipleChoice;

  QuestionModel({
    required this.questionText,
    required this.answers,
    required this.correctAnswerIndices,
    required this.explanation,
    this.isMultipleChoice = false,
  });
}
