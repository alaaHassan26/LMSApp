class McqQuestion {
  final String? id;
  final String? categoryId;
  final String? questionText;
  final int? showResult;
  final List<Choice>? choices;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  McqQuestion({
    this.id,
    this.categoryId,
    this.questionText,
    this.showResult,
    this.choices,
    this.createdAt,
    this.updatedAt,
  });

  factory McqQuestion.fromJson(Map<String, dynamic> json) {
    var choicesFromJson = json['choices'] as List?;
    List<Choice>? choicesList = choicesFromJson?.map((choice) => Choice.fromJson(choice)).toList();

    return McqQuestion(
      id: json['id'] as String?,
      categoryId: json['category_id'] as String?,
      questionText: json['question_text'] as String?,
      showResult: json['show_result'] as int?,
      choices: choicesList,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'question_text': questionText,
      'show_result': showResult,
      'choices': choices?.map((choice) => choice.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class Choice {
  final String? id;
  final String? questionId;
  final String? choiceText;
  final int? isCorrect;
  final String? isCorrectText;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Choice({
    this.id,
    this.questionId,
    this.choiceText,
    this.isCorrect,
    this.isCorrectText,
    this.createdAt,
    this.updatedAt,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'] as String?,
      questionId: json['question_id'] as String?,
      choiceText: json['choice_text'] as String?,
      isCorrect: json['is_correct'] as int?,
      isCorrectText: json['is_correct_text'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'choice_text': choiceText,
      'is_correct': isCorrect,
      'is_correct_text': isCorrectText,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
