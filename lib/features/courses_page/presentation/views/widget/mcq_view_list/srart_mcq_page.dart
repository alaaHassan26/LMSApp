import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/core/widget/custom_image.dart';

import '../../../../../../core/functions/direction_arabic.dart';
import '../../../manger/mcq_cubit/mcq_cubit.dart';
import '../../../manger/mcq_cubit/mcq_state.dart'; 

class StartMcqPage extends StatefulWidget {

  final String questions ;
  final String title ;
  const StartMcqPage({super.key, required this.questions, required this.title});

  @override
  _StartMcqPageState createState() => _StartMcqPageState();
}

class _StartMcqPageState extends State<StartMcqPage> {
  @override
  void initState() {
    super.initState();
    final mcqCubit = context.read<McqCubit>();
    mcqCubit.getQuestions(widget.questions); 

    print(widget.questions);
    

  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? null : greyColor.shade300,
      appBar: AppBar(
        backgroundColor: isDarkMode ? null : greyColor.shade300,
        title: Text( widget.title),
      ),
      body: BlocBuilder<McqCubit, McqState>(
        builder: (context, state) {
          if (state is McqLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is McqFailure) {

            print(state.errorMessage);
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else if (state is McqSuccess) {
            final questions = state.questions;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                   'MCQ Question',
                        style: AppStyles.styleSemiBold24(context),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
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
                            const SizedBox(height: 16),
                            Text(
                              textAlign: TextAlign.center,
                              style: AppStyles.styleMedium20(context),
                               widget.title,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                              child: Divider(),
                            ),
                            CustomImage(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * .25,
                              image: 'https://www.shutterstock.com/image-photo/training-courses-business-concept-stack-260nw-549736798.jpg',
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 120, vertical: 6),
                              child: Divider(),
                            ),
                            const SizedBox(height: 90),
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
                                      style: AppStyles.styleMedium20(context),
                                    ),
                                  ),
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
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(); // Default empty container if no state matched
        },
      ),
    );
  }
}
