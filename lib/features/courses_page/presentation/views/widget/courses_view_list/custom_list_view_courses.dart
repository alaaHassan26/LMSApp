import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/courses_page/presentation/views/widget/custom_item_list_view.dart';

import '../../../manger/course_cubit/course_cubit.dart';
import '../../../manger/course_cubit/course_state.dart';

class CustomListViewCourses extends StatelessWidget {
  const CustomListViewCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoursesCubit()..fetchCourses(),
      child: BlocBuilder<CoursesCubit, CoursesState>(
        builder: (context, state) {
          if (state is CoursesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CoursesError) {
            return Center(child: Text(state.message));
          } else if (state is CoursesLoaded) {
            return ListView.builder(
              itemCount: state.courses.length,
              itemBuilder: (context, index) {
                final course = state.courses[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Card(
                    elevation: 2,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: CustomItemListView(image: course.image,
                      courseTitle: course.title,
                      courseNumber: '${course.timeCourse} ${course.timeType}',
                      onTap: () {
                        print(course.courseId);
                        GoRouter.of(context).push(AppRouter.kListLessonBody , extra: course.id);
                      },
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox(); 
        },
      ),
    );
  }
}
