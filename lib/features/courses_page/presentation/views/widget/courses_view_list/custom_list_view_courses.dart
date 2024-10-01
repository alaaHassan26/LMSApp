import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/courses_page/presentation/views/widget/custom_item_list_view.dart';
import '../../../manger/course_cubit/course_cubit.dart';
import '../../../manger/course_cubit/course_state.dart';

class CustomListViewCourses extends StatefulWidget {
  const CustomListViewCourses({super.key});

  @override
  _CustomListViewCoursesState createState() => _CustomListViewCoursesState();
}

class _CustomListViewCoursesState extends State<CustomListViewCourses> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch initial courses when the widget is built
    context.read<CoursesCubit>().fetchCourses();

    _scrollController.addListener(() {
      // Check if we've scrolled to the bottom
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Check if there are more courses to load
        final cubit = context.read<CoursesCubit>();
        if (cubit.hasMoreCourses && !(cubit.state is CoursesLoading)) { // Correctly checking the state
          cubit.fetchCourses();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesCubit, CoursesState>(
      builder: (context, state) {
        if (state is CoursesLoading && context.read<CoursesCubit>().allCourses.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CoursesError) {
          return Center(child: Text(state.error));
        } else if (state is CoursesLoaded) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.hasMoreCourses ? state.courses.length + 1 : state.courses.length,
            itemBuilder: (context, index) {
              if (index < state.courses.length) {
                final course = state.courses[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Card(
                    elevation: 2,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: CustomItemListView(
                      image: course.image,
                      courseTitle: course.title,
                      courseNumber: '${course.timeCourse} ${course.timeType}',
                      onTap: () {
                        print(course.courseId);
                        GoRouter.of(context).push(AppRouter.kListLessonBody, extra: course.id);
                      },
                    ),
                  ),
                );
              } else {
                // Show loading indicator at the bottom when more courses are being loaded
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        }
        return const SizedBox(); // Return empty widget if no state matches
      },
    );
  }
}
