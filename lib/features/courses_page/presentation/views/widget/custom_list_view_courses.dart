import 'package:flutter/material.dart';
import 'package:lms/features/courses_page/presentation/views/widget/custom_item_list_view.dart';

class CustomListViewCourses extends StatelessWidget {
  const CustomListViewCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: CustomItemListView()),
        );
      },
    );
  }
}
