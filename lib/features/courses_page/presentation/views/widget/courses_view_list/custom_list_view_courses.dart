import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';

import 'package:lms/core/utils/colors.dart';
import 'package:lms/core/widget/snackbar.dart';

import 'package:lms/features/courses_page/presentation/manger/course_cubit/courses_cubit_cubit.dart';
import 'package:lms/features/courses_page/presentation/views/widget/custom_item_list_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomListViewCourses extends StatefulWidget {
  const CustomListViewCourses({super.key});

  @override
  State<StatefulWidget> createState() => _CustomListViewCoursesState();
}

class _CustomListViewCoursesState extends State<CustomListViewCourses> {
  late final ScrollController _scrollController;
  var skip = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<CoursesCubitCubit>().fetchCourses();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
            0.7 * _scrollController.position.maxScrollExtent &&
        !isLoading) {
      setState(() {
        isLoading = true;
      });
      skip++;
      await BlocProvider.of<CoursesCubitCubit>(context)
          .fetchCourses(skip: skip);

      // في حال وجود خطأ أثناء التمرير، إخفاء مؤشر التحميل بعد 3 ثوانٍ
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BlocConsumer<CoursesCubitCubit, CoursesCubitState>(
      listener: (context, state) {
        if (state is CoursesSkipError) {
          CustomSnackbar.showSnackBar(context, state.error,
              AppStyles.styleMedium16(context).copyWith(color: Colors.white));
          // إخفاء مؤشر التحميل عند حدوث خطأ أثناء التمرير
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              isLoading = false;
            });
          });
        }
      },
      builder: (context, state) {
        final cubit = context.read<CoursesCubitCubit>();
        final courses = cubit.allCourses;

        if (cubit.isInitialLoading) {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: isDarkMode ? Colors.white : Colors.black,
              size: 56,
            ),
          );
        } else if (state is CoursesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 56),
                const SizedBox(height: 8),
                Text(
                  state.error,
                  style: AppStyles.styleMedium16(context)
                      .copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CoursesCubitCubit>().fetchCourses();
                  },
                  child: const Text('حاول مجدداً'),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            controller: _scrollController,
            itemCount: courses.length + (cubit.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < courses.length) {
                final course = courses[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    color: isDarkMode ? null : whiteColor,
                    elevation: 2,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: CustomItemListView(
                      image: course.image,
                      courseTitle: course.title,
                      courseNumber: '${course.timeCourse} ${course.timeType}',
                      onTap: () {
                        GoRouter.of(context)
                            .push(AppRouter.kListLessonBody, extra: course.id);
                      },
                    ),
                  ),
                );
              } else {
                // مؤشر التحميل في نهاية التمرير
                return Padding(
                  padding: isLoading
                      ? const EdgeInsets.symmetric(vertical: 20)
                      : const EdgeInsets.symmetric(vertical: 0),
                  child: Center(
                    child: isLoading
                        ? LoadingAnimationWidget.staggeredDotsWave(
                            color: isDarkMode ? Colors.white : Colors.black,
                            size: 36,
                          )
                        : const SizedBox
                            .shrink(), // إخفاء مؤشر التحميل إذا لم يكن هناك تحميل
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
