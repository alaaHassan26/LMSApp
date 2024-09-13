import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/widget/snackbar.dart';
import 'package:lms/features/courses_page/data/models/question_model.dart';
import 'package:lms/features/courses_page/presentation/views/widget/mcq_view_list/custom_question_widget.dart';

class McqQuestionPage extends StatefulWidget {
  const McqQuestionPage({super.key});

  @override
  State<StatefulWidget> createState() => _McqQuestionPageState();
}

class _McqQuestionPageState extends State<McqQuestionPage> {
  List<QuestionModel> questions = [
    QuestionModel(
      questionText: 'هل علي عبد الشهيد ديوث؟',
      answers: ['نعم', 'لا', 'لا اعلم', 'من الممكن'],
      correctAnswerIndices: [0],
      explanation: 'نعم انه ديوث بسبب هواي احمال عنده شالوهن',
    ),
    QuestionModel(
      questionText: 'من الذي يلعقب بأبو رقية المتقاعد؟',
      answers: ['علي حسين عبدالائمة', 'علي حسين هدهود', 'علاء حسن ضمد'],
      correctAnswerIndices: [0],
      explanation:
          'ابو رقية المتقاعد هو لقب اطلقه علاء على علي حسين عبدالائمة بسبب حبه للهمر',
    ),
    QuestionModel(
      questionText:
          'علاء حسن ضمد عندما كان يفتح ميت للطلاب ماذا كان يدرس؟ يجب الاجابة على ثلاثة اختيارات',
      answers: ['RTS', 'عربي', 'امنية', 'نظرية معلومات', 'علوم قران'],
      correctAnswerIndices: [0, 2, 3],
      explanation:
          'الدكتور المهندس علاء حسن ضمد كان يدرس التكنلوجيا العلمية للطلاب ولكنه ايضا يمكنه تدرسين العديد من المواد مثل العربي وعلوم القران ولكنه مختص في المعلومات الرقمية لذلك كان يدرس RTS ونظرية المعلومات والامنية',
    ),
    QuestionModel(
      questionText: 'اختر تعريف ابو الخوخ',
      answers: [
        ' انه امراء',
        'يحب اللون الاحمر',
        ' هو مصطفى فاضل الملقب بأبو الخوخ عمره لا يتجاوز ال24 سنة شخص غير معروفة شخصيته او يمكن القول ليس له شخصية يحب اللون الاخضر الفاتح لا يحب العلاقات المفتوحه يريد على السجين'
      ],
      correctAnswerIndices: [2],
      explanation: "المعرف لا يعرف",
    ),
    QuestionModel(
      questionText: 'ما هو زمن الذيب الحقيقي؟',
      answers: [
        'قبل الميلاد',
        ' بعد الميلاد',
      ],
      correctAnswerIndices: [0],
      explanation: " الحزين ",
    ),
    QuestionModel(
      questionText: 'متى اختفاء سيد كرار',
      answers: [
        ' قبل الزواج',
        ' بعد الزواج',
      ],
      correctAnswerIndices: [1],
      explanation: " الحزين ",
    ),
  ];

  List<List<int>> selectedAnswers = [];
  bool showResults = false;
  bool showWarnings = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    selectedAnswers = List<List<int>>.generate(questions.length, (index) => []);
  }

  void _showResults() {
    bool allQuestionsAnswered = true;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i].length !=
          questions[i].correctAnswerIndices.length) {
        allQuestionsAnswered = false;
        break;
      }
    }

    if (!allQuestionsAnswered) {
      setState(() {
        showWarnings = true;
      });
      CustomSnackbar.showSnackBar(
          context,
          AppLocalizations.of(context)!
              .translate('please_answer_all_questions_completely'),
          AppStyles.styleMedium20(context).copyWith(color: Colors.white));
    } else {
      _calculateScore();
      setState(() {
        showResults = true;
        showWarnings = false;
      });

      showScoreDialog(context, score);
    }
  }

  void _calculateScore() {
    int correctAnswersCount = 0;
    for (int i = 0; i < questions.length; i++) {
      if (const ListEquality()
          .equals(selectedAnswers[i], questions[i].correctAnswerIndices)) {
        correctAnswersCount++;
      }
    }
    score = (correctAnswersCount / questions.length * 100).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MCQ Quiz',
          style: AppStyles.styleSemiBold24(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return QuestionWidget(
                    question: questions[index],
                    questionIndex: index,
                    selectedAnswers: selectedAnswers,
                    showResults: showResults,
                    showWarnings: showWarnings,
                    onAnswerSelected: (newSelectedAnswers) {
                      setState(() {
                        selectedAnswers[index] = newSelectedAnswers;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                autofocus: true,
                onPressed: _showResults,
                child: Text(
                  AppLocalizations.of(context)!.translate('view_results'),
                  style: AppStyles.styleMedium20(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
