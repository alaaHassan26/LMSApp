import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/features/courses_page/data/models/question_model.dart';

import '../../../manger/mcq_cubit/mcq_cubit.dart';
import '../../../manger/mcq_cubit/mcq_state.dart';

class QuestionWidget extends StatelessWidget {
  final McqQuestion question;
  final String QuestionId;
  final int questionIndex;
  final List<List<int>> selectedAnswers;
  final int showResults;
  final int showWarnings;
  final Function(List<int>) onAnswerSelected;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.questionIndex,
    required this.selectedAnswers,
    required this.showResults, // This will now accept an int
    required this.showWarnings, // This will now accept an int
    required this.onAnswerSelected,
    required this.QuestionId,
  });

  bool _isAnswerCorrect(int index) {
    return question.choices![index].isCorrect == 1;
  }

  bool _isAnswerSelected(int index) {
    return selectedAnswers[questionIndex].contains(index);
  }

  bool _isAnswerIncomplete() {
    final correctAnswersCount =
        question.choices!.where((choice) => choice.isCorrect == 1).length;
    return selectedAnswers[questionIndex].length != correctAnswersCount;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                  Text(
                    question.questionText!,
                    textAlign: TextAlign.center,
                    style: AppStyles.styleMedium24(context),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 42, vertical: 5),
                    child: Divider(),
                  ),
                  _buildAnswerOptions(context, isDarkMode),
                  if (showWarnings == 1 &&
                      _isAnswerIncomplete()) // Updated condition to check for int value
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
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions(BuildContext context, bool isDarkMode) {
    final mcqCubit = BlocProvider.of<McqCubit>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: List.generate(question.choices!.length, (index) {
          bool isCorrect = _isAnswerCorrect(index);
          bool isSelected = _isAnswerSelected(index);

          return Padding(
            padding: const EdgeInsets.all(6),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 3),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              elevation: 1,
              color: isDarkMode ? Colors.black : Colors.white,
              child: BlocBuilder<McqCubit, McqState>(
                builder: (context, state) {
                  return ListTile(
                    leading: _buildLeadingIcon(
                      onPressed: () {
                        isCorrect
                            ? mcqCubit.getQuestionResults(
                                questionId: QuestionId)
                            : print(
                                'no thing'); // Make sure `question.id` is the correct variable
                        print(question.id);
                        _handleAnswerSelection(index);
                      },
                      isCorrect: isCorrect,
                      isSelected: isSelected,
                    ),
                    title: Text(
                      question.choices![index].choiceText!,
                      style: AppStyles.styleMedium18(context),
                    ),
                    trailing: showResults == 1 && isCorrect
                        ? _buildInfoIcon(
                            context, question.choices![index].isCorrectText!)
                        : null,
                    onTap: () => _handleAnswerSelection(index),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLeadingIcon({
    required bool isCorrect,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(
        isSelected
            ? (isCorrect ? Icons.check_circle : Icons.cancel)
            : Icons.radio_button_unchecked,
        color: isSelected ? (isCorrect ? Colors.green : Colors.red) : null,
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildInfoIcon(BuildContext context, String explanation) {
    return IconButton(
      icon: const Icon(
        Icons.info_outline,
        color: Colors.green,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.translate('clarify_the_answer'),
              style: AppStyles.styleMedium20(context),
            ),
            content: Text(
              explanation,
              style: AppStyles.styleMedium18(context),
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
      },
    );
  }

  void _handleAnswerSelection(int index) {
    List<int> newSelectedAnswers = List.from(selectedAnswers[questionIndex]);

    if (!newSelectedAnswers.contains(index)) {
      final correctAnswersCount =
          question.choices!.where((choice) => choice.isCorrect == 1).length;
      if (newSelectedAnswers.length < correctAnswersCount) {
        newSelectedAnswers.add(index);
      }
    } else {
      newSelectedAnswers.remove(index);
    }

    onAnswerSelected(newSelectedAnswers);
  }
}
