import 'package:flutter/material.dart';
import 'package:lms/features/courses_page/data/models/video_links.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/custom_item_lesson_listview.dart';

class CustomLessonListView extends StatelessWidget {
  const CustomLessonListView({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة الفيديوهات
    List<VideoLinksModel> videos = [
      const VideoLinksModel(
        videoLink: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
        videoTitle: 'الفيديو الأول',
      ),
      const VideoLinksModel(
        videoLink: 'https://test-streams.mux.dev/test_001/stream.m3u8',
        videoTitle: 'الفيديو الثاني',
      ),
      const VideoLinksModel(
        videoLink:
            'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8',
        videoTitle: 'الفيديو الثالث',
      ),
      const VideoLinksModel(
        videoLink: 'https://youtu.be/6uCMEZU3J68?si=FNjJmzv_lqaqN4m6',
        videoTitle: 'الفيديو الرابع',
      ),
      const VideoLinksModel(
        videoLink: 'https://youtu.be/LXb3EKWsInQ?si=B9FZVJymEMl74nlD',
        videoTitle: 'الفيديو الخامس',
      ),
    ];

    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        // تمرير قائمة الفيديوهات والفهرس الحالي إلى CustomItemLessonListView
        return CustomItemLessonListView(
          videos: videos, // تمرير القائمة الكاملة
          index: index, // تمرير الفهرس الحالي
        );
      },
    );
  }
}
