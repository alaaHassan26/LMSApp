import 'package:flutter/material.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/features/courses_page/presentation/views/widget/custom_item_list_view.dart';

class CustomListViewCourses extends StatelessWidget {
  const CustomListViewCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Card(
              elevation: 2,
              color: isDarkMode ? null : whiteColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: const CustomItemListView()),
        );
      },
    );
  }
}
