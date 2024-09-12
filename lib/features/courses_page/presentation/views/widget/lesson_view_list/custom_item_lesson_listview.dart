import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/widget/custom_image.dart';

class CustomItemLessonListView extends StatelessWidget {
  const CustomItemLessonListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        child: GestureDetector(
          onTap: () {
            GoRouter.of(context).push(AppRouter.kVideoPlayerBody);
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Card(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Profile Image
                      SizedBox(
                        width: constraints.maxWidth * 0.25,
                        height: constraints.maxWidth * 0.25,
                        child: CustomImage(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width * 0.5,
                          image:
                              'https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg',
                        ),
                      ),
                      const SizedBox(width: 16.0),

                      // Texts (name, description, time)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text('الفصل الاول',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.styleMedium24(context)),
                            ),
                            const SizedBox(height: 4.0),
                            SizedBox(
                              child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  'برمجة الاردوينو بواسطة لغة اردوينو المبنيه على لغة c++ و c المهندس علاء',
                                  style: AppStyles.styleMedium20(context)),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12.0),
                      IconButton(
                        onPressed: () {
                          GoRouter.of(context).push(AppRouter.kVideoPlayerBody);
                        },
                        icon: Icon(isArabic(context)
                            ? Iconsax.arrow_circle_left
                            : Iconsax.arrow_circle_right),
                      ),

                      // Attached Image
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
