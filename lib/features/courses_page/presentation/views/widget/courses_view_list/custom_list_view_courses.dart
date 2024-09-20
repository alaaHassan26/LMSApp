import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/courses_page/presentation/views/widget/custom_item_list_view.dart';

class CustomListViewCourses extends StatelessWidget {
  const CustomListViewCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Card(
              elevation: 2,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: CustomItemListView(
                courseTitle:
                    AppLocalizations.of(context)!.translate('cours_title'),
                courseNumber:
                    AppLocalizations.of(context)!.translate('cours_num'),
                onTap: () {
                  GoRouter.of(context).push(AppRouter.kListLessonBody);
                },
              )),
        );
      },
    );
  }
}
