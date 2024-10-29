import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/features/courses_page/presentation/manger/lessons_cubit/lessons_cubit.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/custom_lesson_listviws.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../manger/lessons_cubit/lessons_state.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/utils/appstyles.dart';

class ListLessonBody extends StatelessWidget {
  final String categoryId;

  const ListLessonBody({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? black38Color : greyColor2,
      appBar: AppBar(
        backgroundColor: isDarkMode ? black38Color : greyColor2,
        actions: [
          BlocBuilder<LessonsCubit, LessonsState>(
            builder: (context, state) {
              String timeCourse = '0';
              String timeType = '';

              if (state is LessonsLoaded && state.lessons.isNotEmpty) {
                timeCourse = state.lessons[0].course!.timeCourse;
                timeType = state.lessons[0].course!.timeType;
              }

              return Row(
                children: [
                  Text('$timeCourse $timeType',
                      style: AppStyles.styleMedium18(context)),
                  const SizedBox(width: 3),
                  const Icon(Iconsax.video_time),
                  const SizedBox(width: 12),
                ],
              );
            },
          ),
        ],
        title: BlocBuilder<LessonsCubit, LessonsState>(
          builder: (context, state) {
            String nameOfCourse = "Course";

            if (state is LessonsLoaded && state.lessons.isNotEmpty) {
              nameOfCourse = state.lessons[0].course!.title;
            }
            if (state is NoLessons) {
              nameOfCourse = 'لا توجد دروس';
            }

            return Text(
              nameOfCourse,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.styleMedium24(context),
            );
          },
        ),
      ),
      body: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) {
          if (state is LessonsLoading) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: isDarkMode ? Colors.white : Colors.black,
                size: 56,
              ),
            );
          } else if (state is LessonsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 56),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: AppStyles.styleMedium16(context)
                        .copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<LessonsCubit>()
                          .fetchLesson(categoryId: categoryId);
                    },
                    child: const Text('حاول مجدداً'),
                  ),
                ],
              ),
            );
          } else if (state is LessonsLoaded) {
            return CustomLessonListView(videos: state.lessons);
          } else if (state is NoLessons) {
            return Center(
              child: Text(
                'لا توجد دروس',
                style: AppStyles.styleBold16(context),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
