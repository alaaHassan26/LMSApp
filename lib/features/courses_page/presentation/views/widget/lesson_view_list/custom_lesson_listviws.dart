import 'package:flutter/material.dart';
import 'package:lms/features/courses_page/data/models/lessons_model.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/custom_item_lesson_listview.dart';

class CustomLessonListView extends StatelessWidget {
  final List<Lesson> videos; 

  const CustomLessonListView({super.key, required this.videos}); 

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return CustomItemLessonListView(
          videos: videos, 
          index: index,
        );
      },
    );
  }
}
