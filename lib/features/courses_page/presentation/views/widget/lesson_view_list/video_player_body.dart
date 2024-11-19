import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/Constatns.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/features/courses_page/data/models/lessons_model.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/comment_video_lesson.dart';
import 'package:lms/core/widget/download_pdf_page.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'custom_video_player.dart';

class VideoPlayerBody extends StatelessWidget {
  final List<Lesson> videos;
  final int initialIndex;

  const VideoPlayerBody({
    super.key,
    required this.videos,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    void showCommentsSheet(BuildContext context) {
      showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (context) => const SizedBox(),
        // builder: (context) => const CommentsVideoLesson(),
      );
    }

    return Scaffold(
      backgroundColor: isDarkMode ? black38Color : greyColor2,
      appBar: AppBar(
        backgroundColor: isDarkMode ? black38Color : greyColor2,
        actions: [
          GestureDetector(
            onTap: () => showCommentsSheet(context),
            child: const Icon(Iconsax.message),
          ),
          const SizedBox(width: 24),
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
  final List<Lesson> videos;
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemCount: widget.videos.length,
      itemBuilder: (context, index) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .3,
                width: double.infinity,
                child: CustomVideoPlayer(
                  videoUrl: widget.videos[index].video != null &&
                          widget.videos[index].video!.isNotEmpty
                      ? '${CS.Api}${widget.videos[index].video}'
                      : (widget.videos[index].videoUrl != null &&
                              widget.videos[index].videoUrl!.isNotEmpty
                          ? 'https://youtu.be/${widget.videos[index].videoUrl}'
                          : ''),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  color: isDarkMode ? null : whiteColor,
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
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.videos[_currentIndex].title!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.styleMedium24(context),
                ),
              ),
              const SizedBox(height: 12),
              const Divider(color: primaryColor, thickness: 3),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الوصف:',
                      style: AppStyles.styleSemiBold24(context),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ReadMoreText(
                      widget.videos[index].content!,
                      style: AppStyles.styleMedium20(context),
                      trimLines: 3,
                      trimCollapsedText:
                          AppLocalizations.of(context)!.translate('showmore'),
                      trimExpandedText:
                          AppLocalizations.of(context)!.translate('showless'),
                    ),
                    const SizedBox(height: 12),
                    Divider(
                      thickness: 3,
                      color: isDarkMode ? null : whiteColor,
                    ),
                    const SizedBox(height: 24),
                    widget.videos[index].file != null
                        ? DownloadPdfPage(
                            pdfName: 'Pdf', pdfUrl: widget.videos[index].file!)
                        : Center(
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/no-attachment-svgrepo-com.svg',
                                  height:
                                      MediaQuery.of(context).size.height * .12,
                                  width:
                                      MediaQuery.of(context).size.width * .12,
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  'لا توجد ملفات مرفقة',
                                  style: AppStyles.styleMedium24(context),
                                ),
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
