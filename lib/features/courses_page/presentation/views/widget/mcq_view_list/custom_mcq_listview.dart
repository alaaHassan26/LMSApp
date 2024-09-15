import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/courses_page/presentation/views/widget/mcq_view_list/custom_item_mcq_listview.dart';

class CustomMcqListView extends StatelessWidget {
  const CustomMcqListView({super.key});

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
              child: CustomItemMcqListView(
                courseTitle: 'اسم المادة',
                courseNumber: "عدد الاسئلة 5",
                onTap: () {
                  GoRouter.of(context).push(AppRouter.kStartMcqPage);
                },
              )),
        );
      },
    );
  }
}
