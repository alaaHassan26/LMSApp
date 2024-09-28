import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/widget/custom_image.dart';
import 'package:lms/features/courses_page/data/models/lessons_model.dart';
class CustomItemLessonListView extends StatelessWidget {
  final List<Lesson> videos; // List of videos
  final int index; 

  const CustomItemLessonListView({
    super.key,
    required this.videos,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        child: GestureDetector(
          onTap: () => _navigateToVideoPlayer(context),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Card(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: constraints.maxWidth * 0.25,
                        height: constraints.maxWidth * 0.25,
                        child: CustomImage(
                          width: double.infinity,
                          height: double.infinity,
                          image: videos[index].image?.isNotEmpty == true 
                              ? videos[index].image! 
                              : 'https://via.placeholder.com/150',
                          // Handle image loading errors (if needed)
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              videos[index].title ?? 'عنوان غير متوفر',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.styleMedium24(context),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              videos[index].content ?? 'وصف غير متوفر',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.styleMedium20(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      IconButton(
                        onPressed: () => _navigateToVideoPlayer(context),
                        icon: Icon(isArabic(context)
                            ? Iconsax.arrow_circle_left
                            : Iconsax.arrow_circle_right),
                      ),
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

  void _navigateToVideoPlayer(BuildContext context) {
    GoRouter.of(context).push(AppRouter.kVideoPlayerBody, extra: {
      'videos': videos,
      'initialIndex': index,
    });
  }
}
