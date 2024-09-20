import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/core/widget/custom_image.dart';
import 'package:lms/features/courses_page/data/models/question_model.dart';

class StartMcqPage extends StatelessWidget {
  const StartMcqPage({super.key});

  @override
  Widget build(BuildContext context) {
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? null : greyColor.shade300,
      appBar: AppBar(
        backgroundColor: isDarkMode ? null : greyColor.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  'MCQ',
                  style: AppStyles.styleSemiBold24(context),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            SliverToBoxAdapter(
              child: Card(
                elevation: 6,
                color: isDarkMode ? null : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        AppLocalizations.of(context)!.translate('exam_name'),
                        style: AppStyles.styleMedium16(context),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                          textAlign: TextAlign.center,
                          style: AppStyles.styleMedium20(context),
                          'اختبار مادة الفيزياء للصف السادس اعدادي العلمي التطبيقي.'),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                        child: Divider(),
                      ),
                      CustomImage(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * .25,
                          image:
                              'https://www.shutterstock.com/image-photo/training-courses-business-concept-stack-260nw-549736798.jpg'),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 120, vertical: 6),
                        child: Divider(),
                      ),
                      const SizedBox(
                        height: 90,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  const Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context)
                          .go(AppRouter.kMcqQuestionPage, extra: questions);
                    },
                    child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    GoRouter.of(context).go(
                                        AppRouter.kMcqQuestionPage,
                                        extra: questions);
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('start_youer_test'),
                                      style: AppStyles.styleMedium20(context))),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  GoRouter.of(context).go(
                                      AppRouter.kMcqQuestionPage,
                                      extra: questions);
                                },
                                icon: Icon(isArabic(context)
                                    ? Iconsax.arrow_circle_left
                                    : Iconsax.arrow_circle_right),
                              ),
                            ],
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
