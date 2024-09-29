class QuestionModel {
  final String? questionText;
  final List<String>? answers;
  final List<int>? correctAnswerIndices;
  final String? explanation;

  QuestionModel({
    this.questionText,
    this.answers,
    this.correctAnswerIndices,
    this.explanation,
  });

  // From JSON constructor
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      questionText: json['questionText'] as String?,
      answers: json['answers'] != null
          ? List<String>.from(json['answers'])
          : null,
      correctAnswerIndices: json['correctAnswerIndices'] != null
          ? List<int>.from(json['correctAnswerIndices'])
          : null,
      explanation: json['explanation'] as String?,
    );
  }

  // To JSON method if needed
  Map<String, dynamic> toJson() {
    return {
      'questionText': questionText,
      'answers': answers,
      'correctAnswerIndices': correctAnswerIndices,
      'explanation': explanation,
    };
  }
}

class McqQuestion {
  final String? id;
  final String? categoryId;
  final String? questionText;
  final int? showResult;
  final List<Choice>? choices;

  McqQuestion({
    this.id,
    this.categoryId,
    this.questionText,
    this.showResult,
    this.choices,
  });

  factory McqQuestion.fromJson(Map<String, dynamic> json) {
    var choicesFromJson = json['choices'] as List?;
    List<Choice>? choicesList = choicesFromJson != null
        ? choicesFromJson.map((choice) => Choice.fromJson(choice)).toList()
        : null;

    return McqQuestion(
      id: json['id'] as String?,
      categoryId: json['category_id'] as String?,
      questionText: json['question_text'] as String?,
      showResult: json['show_result'] as int?,
      choices: choicesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'question_text': questionText,
      'show_result': showResult,
      'choices': choices?.map((choice) => choice.toJson()).toList(),
    };
  }
}

class Choice {
  final String? id;
  final String? questionId;
  final String? choiceText;
  final int? isCorrect;
  final String? isCorrectText;

  Choice({
    this.id,
    this.questionId,
    this.choiceText,
    this.isCorrect,
    this.isCorrectText,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'] as String?,
      questionId: json['question_id'] as String?,
      choiceText: json['choice_text'] as String?,
      isCorrect: json['is_correct'] as int?,
      isCorrectText: json['is_correct_text'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'choice_text': choiceText,
      'is_correct': isCorrect,
      'is_correct_text': isCorrectText,
    };
  }
}
