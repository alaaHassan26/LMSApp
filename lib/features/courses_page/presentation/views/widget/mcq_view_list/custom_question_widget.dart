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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    bool isAnswerIncomplete = selectedAnswers[questionIndex].length !=
        question.correctAnswerIndices!.length;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Card(
            elevation: 6,
            color: isDarkMode ? null : Colors.white.withOpacity(0.90),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(question.questionText!,
                      textAlign: TextAlign.center,
                      style: AppStyles.styleMedium24(context)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 42, vertical: 5),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: List.generate(question.answers!.length, (index) {
                        bool isCorrect =
                            question.correctAnswerIndices!.contains(index);
                        bool isSelected =
                            selectedAnswers[questionIndex].contains(index);

                        return Padding(
                          padding: const EdgeInsets.all(6),
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            elevation: 1,
                            color: isDarkMode ? Colors.black : Colors.white,
                            child: ListTile(
                              leading: isSelected
                                  ? Icon(
                                      isCorrect
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color:
                                          isCorrect ? Colors.green : Colors.red,
                                    )
                                  : const Icon(Icons.radio_button_unchecked),
                              title: Text(question.answers![index],
                                  style: AppStyles.styleMedium18(context)),
                              trailing: showResults && isCorrect
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
                                                  .translate(
                                                      'clarify_the_answer'),
                                              style: AppStyles.styleMedium20(
                                                  context),
                                            ),
                                            content: Text(
                                              question.explanation!,
                                              style: AppStyles.styleMedium18(
                                                  context),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .translate('okay'),
                                                  style:
                                                      AppStyles.styleMedium20(
                                                          context),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : null,
                              onTap: () {
                                List<int> newSelectedAnswers =
                                    List.from(selectedAnswers[questionIndex]);

                                if (!newSelectedAnswers.contains(index)) {
                                  if (newSelectedAnswers.length <
                                      question.correctAnswerIndices!.length) {
                                    newSelectedAnswers.add(index);
                                  }
                                } else {
                                  newSelectedAnswers.remove(index);
                                }

                                onAnswerSelected(newSelectedAnswers);
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  if (showWarnings && isAnswerIncomplete)
                    Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          AppLocalizations.of(context)!.translate(
                              'please_select_the_required_number_of_answers'),
                          style: const TextStyle(color: Colors.red),
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
