import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/comment_video_lesson.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/custom_video_player.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/list_view_video_accessories.dart';

class VideoPlayerBody extends StatelessWidget {
  const VideoPlayerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              const SizedBox(
                height: 1,
              ),
              const CustomVideoPlayer(),
              Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(isArabic(context)
                            ? Iconsax.arrow_circle_right
                            : Iconsax.arrow_circle_left),
                      ),
                      const Text('التالي'),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Text('السابق'),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(isArabic(context)
                            ? Iconsax.arrow_circle_left
                            : Iconsax.arrow_circle_right),
                      ),
                    ],
                  ),
                ],
              ),
              ListTile(
                title: SizedBox(
                  child: Text(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      'برمجة الاردوينو بواسطة لغة اردوينو المبنيه على لغة c++ و c المهندس علاء',
                      style: AppStyles.styleMedium20(context)),
                ),
              ),
              TabBar(
                indicatorColor: Colors.green,
                labelColor: Theme.of(context).colorScheme.primary,
                tabs: const [
                  Tab(text: "الوصف"),
                  Tab(text: "التعليقات"),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [ListViewVideoAccessories(), CommentsVideoLesson()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
