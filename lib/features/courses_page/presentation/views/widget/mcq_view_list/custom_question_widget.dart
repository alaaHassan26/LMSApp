import 'package:flutter/material.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/features/courses_page/data/models/question_model.dart';

class QuestionWidget extends StatelessWidget {
  final QuestionModel question;
  final int questionIndex;
  final List<List<int>> selectedAnswers;
  final bool showResults;
  final bool showWarnings;
  final Function(List<int>) onAnswerSelected;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.questionIndex,
    required this.selectedAnswers,
    required this.showResults,
    required this.showWarnings,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    bool isAnswerIncomplete = selectedAnswers[questionIndex].length !=
        question.correctAnswerIndices.length;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: AppStyles.styleMedium24(context),
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(question.answers.length, (index) {
                bool isCorrect = question.correctAnswerIndices.contains(index);
                bool isSelected =
                    selectedAnswers[questionIndex].contains(index);

                return CheckboxListTile(
                  title: Text(
                    textAlign: TextAlign.justify,
                    question.answers[index],
                    style: AppStyles.styleMedium20(context),
                  ),
                  value: isSelected,
                  onChanged: (value) {
                    List<int> newSelectedAnswers =
                        List.from(selectedAnswers[questionIndex]);
                    if (value == true) {
                      if (newSelectedAnswers.length <
                          question.correctAnswerIndices.length) {
                        newSelectedAnswers.add(index);
                      }
                    } else {
                      newSelectedAnswers.remove(index);
                    }
                    onAnswerSelected(newSelectedAnswers);
                  },
                  secondary: showResults && isCorrect
                      ? IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .translate('correct_answer'),
                                  style: AppStyles.styleMedium24(context),
                                ),
                                content: Text(
                                  question.explanation,
                                  style: AppStyles.styleMedium20(context),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('okay'),
                                      style: AppStyles.styleMedium20(context),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : null,
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: showResults
                      ? (isCorrect ? Colors.green : Colors.red)
                      : null,
                );
              }),
            ),
            if (showWarnings && isAnswerIncomplete)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.translate(
                      'please_select_the_required_number_of_answers'),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void showScoreDialog(BuildContext context, int score) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.translate('your_score'),
        style: AppStyles.styleMedium20(context),
      ),
      content: Row(
        children: [
          Text(
            AppLocalizations.of(context)!.translate('your_score'),
            style: AppStyles.styleMedium20(context),
          ),
          const SizedBox(
            width: 6,
          ),
          Text(
            '$score%',
            style: AppStyles.styleMedium20(context),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context)!.translate('okay'),
            style: AppStyles.styleMedium20(context),
          ),
        ),
      ],
    ),
  );
}
