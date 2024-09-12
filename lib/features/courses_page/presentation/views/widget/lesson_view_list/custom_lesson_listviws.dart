import 'package:flutter/material.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/custom_item_lesson_listview.dart';

class CustomLessonListView extends StatelessWidget {
  const CustomLessonListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return const CustomItemLessonListView();
      },
    );
  }
}
