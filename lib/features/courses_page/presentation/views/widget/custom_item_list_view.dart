import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/widget/custom_image.dart';

class CustomItemListView extends StatelessWidget {
  final String courseTitle;

  const CustomItemListView({super.key, required this.courseTitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push(AppRouter.kListLessonBody);
      },
      child: Column(
        children: [
          CustomImage(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 0.5,
            image:
                'https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg',
          ),
          const SizedBox(height: 8),
          ListTile(
            title: Text(
              courseTitle,
              style: AppStyles.styleSemiBold20(context),
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.translate('cours_num'),
              style: AppStyles.styleMedium16(context),
            ),
            trailing: IconButton(
              onPressed: () {
                GoRouter.of(context).push(AppRouter.kListLessonBody);
              },
              icon: Icon(isArabic(context)
                  ? Iconsax.arrow_circle_left
                  : Iconsax.arrow_circle_right),
            ),
          )
        ],
      ),
    );
  }
}
