import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';

import 'package:lms/core/utils/appstyles.dart';

import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/custom_lesson_listviws.dart';

class ListLessonBody extends StatelessWidget {
  const ListLessonBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Text('33'),
          SizedBox(
            width: 3,
          ),
          Icon(Iconsax.video),
          SizedBox(
            width: 12,
          ),
        ],
        title: SizedBox(
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            'أنظمة الوقت الحقيقي(RTS)',
            style: AppStyles.styleMedium24(context),
          ),
        ),
      ),
      body: const CustomLessonListView(),
    );
  }
}
