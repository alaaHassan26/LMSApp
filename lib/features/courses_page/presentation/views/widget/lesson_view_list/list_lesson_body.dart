import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/custom_lesson_listviws.dart';
import '../../../manger/lessons_cubit/lessons_cubit.dart'; 
import '../../../manger/lessons_cubit/lessons_state.dart'; 
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/utils/appstyles.dart';

class ListLessonBody extends StatelessWidget {
  final String categoryId; 

  const ListLessonBody({super.key, required this.categoryId}); 

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LessonsCubit()..fetchLessons(categoryId), 
      child: Scaffold(
        appBar: AppBar(
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
                    Text('$timeCourse $timeType', style: AppStyles.styleMedium18(context)),
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
              return const Center(child: CircularProgressIndicator());
            } else if (state is LessonsError) {
              return Center(child: Text(state.message));
            } else if (state is LessonsLoaded) {
              return CustomLessonListView(videos: state.lessons); 
            }
            else if (state is NoLessons) {
              return Center(child: Text('لا توجد دروس' , style: AppStyles.styleBold16(context),),); 
            }
            return const SizedBox(); 
          },
        ),
      ),
    );
  }
}
