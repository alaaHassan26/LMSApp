class QuestionResult {
  final String id;
  final String categoryId;
  final String questionText;
  final int showResult;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Choice> choices;

  QuestionResult({
    required this.id,
    required this.categoryId,
    required this.questionText,
    required this.showResult,
    required this.createdAt,
    required this.updatedAt,
    required this.choices,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      id: json['id'],
      categoryId: json['category_id'],
      questionText: json['question_text'],
      showResult: json['show_result'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      choices: (json['choices'] as List)
          .map((choice) => Choice.fromJson(choice))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'question_text': questionText,
      'show_result': showResult,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'choices': choices.map((choice) => choice.toJson()).toList(),
    };
  }
}

class Choice {
  final String id;
  final String questionId;
  final String choiceText;
  final int isCorrect;
  final String? isCorrectText;
  final DateTime createdAt;
  final DateTime updatedAt;

  Choice({
    required this.id,
    required this.questionId,
    required this.choiceText,
    required this.isCorrect,
    this.isCorrectText,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'],
      questionId: json['question_id'],
      choiceText: json['choice_text'],
      isCorrect: json['is_correct'],
      isCorrectText: json['is_correct_text'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'choice_text': choiceText,
      'is_correct': isCorrect,
      'is_correct_text': isCorrectText,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
