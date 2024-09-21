import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/features/courses_page/data/models/video_links.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/comment_video_lesson.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/list_view_video_accessories.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'custom_video_player.dart';

class VideoPlayerBody extends StatelessWidget {
  final List<VideoLinksModel> videos;
  final int initialIndex;

  const VideoPlayerBody({
    super.key,
    required this.videos,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    void showCommentsSheet(BuildContext context) {
      showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (context) => const CommentsVideoLesson(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
              onTap: () => showCommentsSheet(context),
              child: const Icon(Iconsax.message)),
          const SizedBox(
            width: 24,
          )
        ],
      ),
      body: VideoPlayerContent(
        videos: videos,
        initialIndex: initialIndex,
      ),
    );
  }
}

class VideoPlayerContent extends StatefulWidget {
  final List<VideoLinksModel> videos;
  final int initialIndex;

  const VideoPlayerContent({
    super.key,
    required this.videos,
    required this.initialIndex,
  });

  @override
  State<StatefulWidget> createState() => _VideoPlayerContentState();
}

class _VideoPlayerContentState extends State<VideoPlayerContent>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  void _nextVideo() {
    if (_currentIndex < widget.videos.length - 1) {
      _currentIndex++;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // الانتقال إلى الصفحة السابقة باستخدام PageController
  void _previousVideo() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemCount: widget.videos.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .3,
                  width: double.infinity,
                  child: CustomVideoPlayer(
                    videoUrl: widget.videos[index].videoLink,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    children: [
                      if (_currentIndex > 0)
                        Row(
                          children: [
                            IconButton(
                              onPressed: _previousVideo,
                              icon: Icon(isArabic(context)
                                  ? Iconsax.arrow_circle_right
                                  : Iconsax.arrow_circle_left),
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('previous'),
                              style: AppStyles.styleMedium16(context),
                            ),
                          ],
                        ),
                      const Spacer(),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: widget.videos.length,
                        effect: const WormEffect(
                          activeDotColor: primaryColor,
                          dotHeight: 8,
                          dotWidth: 8,
                        ),
                      ),
                      const Spacer(),
                      if (_currentIndex < widget.videos.length - 1)
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.translate('next'),
                              style: AppStyles.styleMedium16(context),
                            ),
                            IconButton(
                              onPressed: _nextVideo,
                              icon: Icon(isArabic(context)
                                  ? Iconsax.arrow_circle_left
                                  : Iconsax.arrow_circle_right),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    child: Text(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      widget.videos[_currentIndex].videoTitle,
                      style: AppStyles.styleMedium24(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            const Divider(
              color: primaryColor,
              thickness: 3,
            ),
            const SizedBox(
              height: 12,
            ),
            const ListViewVideoAccessories(),
          ],
        );
      },
    );
  }
}
