import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/features/courses_page/data/models/question_model.dart';
import 'package:lms/features/courses_page/presentation/views/widget/mcq_view_list/custom_question_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class McqQuestionPage extends StatefulWidget {
  final List<McqQuestion> questions;
  const McqQuestionPage({super.key, required this.questions});

  @override
  State<StatefulWidget> createState() => _McqQuestionPageState();
}

class _McqQuestionPageState extends State<McqQuestionPage> {
  List<List<int>> selectedAnswers = [];
  int showResults = 0;
  int showWarnings = 0;
  int correctAnswersCount = 0;
  final PageController _pageController = PageController();
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedAnswers =
        List<List<int>>.generate(widget.questions.length, (index) => []);
  }

  void onAnswerSelected(List<int> newSelectedAnswers) {
    setState(() {
      selectedAnswers[currentQuestionIndex] = newSelectedAnswers;

      final correctAnswers = widget.questions[currentQuestionIndex].choices;

      bool anyCorrectSelected = newSelectedAnswers.any((index) =>
          correctAnswers != null && correctAnswers[index].isCorrect == 1);

      bool anyCorrectWithNullText = newSelectedAnswers.any((index) =>
          correctAnswers != null &&
          correctAnswers[index].isCorrect == 1 &&
          correctAnswers[index].isCorrectText == null);

      if (anyCorrectWithNullText) {
        showResults = 0;
      } else if (anyCorrectSelected) {
        showResults = 1;

        if (correctAnswers != null &&
            newSelectedAnswers.length ==
                correctAnswers
                    .where((choice) => choice.isCorrect == 1)
                    .length) {
          correctAnswersCount++;
        }
      } else {
        showResults = 0;
      }
    });
  }

  void onNextPressed() {
    if (currentQuestionIndex < widget.questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        showWarnings = 0;
        showResults = 0;
      });
    } else {
      GoRouter.of(context).go(AppRouter.kResultsPage, extra: {
        'totalQuestions': widget.questions.length,
        'correctAnswers': correctAnswersCount,
      });
    }
  }

  void onPreviousPressed() {
    if (currentQuestionIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        showResults = 0;
        showWarnings = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? null : greyColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? null : greyColor,
        title: Text(
          'MCQ',
          style: AppStyles.styleSemiBold24(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${currentQuestionIndex + 1} / ${widget.questions.length}',
              style: AppStyles.styleSemiBold20(context),
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: widget.questions.length,
            effect: const WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: primaryColor,
            ),
          ),
          Expanded(
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: widget.questions.length,
              onPageChanged: (index) {
                setState(() {
                  currentQuestionIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: QuestionWidget(
                    QuestionId: widget.questions[index].id!,
                    question: widget.questions[index],
                    questionIndex: index,
                    selectedAnswers: selectedAnswers,
                    showResults: showResults,
                    showWarnings: showWarnings,
                    onAnswerSelected: onAnswerSelected,
                  ),
                );
              },
            ),
          ),
          if (showWarnings == 1)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!
                    .translate('select_answer_warning'),
                style: AppStyles.styleMedium16(context)
                    .copyWith(color: Colors.red),
              ),
            ),
          Row(
            children: [
              if (currentQuestionIndex > 0)
                GestureDetector(
                  onTap: onPreviousPressed,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        Icon(isArabic(context)
                            ? Iconsax.arrow_circle_right
                            : Iconsax.arrow_circle_left),
                        TextButton(
                          onPressed: onPreviousPressed,
                          child: Text(
                              AppLocalizations.of(context)!
                                  .translate('previous_question'),
                              style: AppStyles.styleMedium20(context)),
                        ),
                      ],
                    ),
                  ),
                ),
              const Spacer(),
              GestureDetector(
                onTap: onNextPressed,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: onNextPressed,
                        child: Text(
                            currentQuestionIndex == widget.questions.length - 1
                                ? AppLocalizations.of(context)!
                                    .translate('submit_test')
                                : AppLocalizations.of(context)!
                                    .translate('next_test'),
                            style: AppStyles.styleMedium20(context)),
                      ),
                      Icon(isArabic(context)
                          ? Iconsax.arrow_circle_left
                          : Iconsax.arrow_circle_right),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
