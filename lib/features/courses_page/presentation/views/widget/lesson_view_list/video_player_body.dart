import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/features/courses_page/presentation/manger/video_cubit/video_cubit.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/comment_video_lesson.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/list_view_video_accessories.dart';
import 'custom_video_player.dart';

class VideoPlayerBody extends StatelessWidget {
  //ابو حسين هنا تخلي رابط الفيديو ويجب ان يكون اما بصيغة
//m3u8
// او mpd
  final List<String> videoUrls = [
    'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
    'https://test-streams.mux.dev/test_001/stream.m3u8',
    'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8'
  ];

  VideoPlayerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VideoCubit(videoUrls),
      child: BlocBuilder<VideoCubit, int>(
        builder: (context, state) {
          final cubit = context.read<VideoCubit>();

          return DefaultTabController(
            length: 2,
            child: SafeArea(
              child: Scaffold(
                body: Column(
                  children: [
                    BlocBuilder<VideoCubit, int>(
                      builder: (context, state) {
                        return CustomVideoPlayer(
                          videoUrl: cubit.getCurrentVideoUrl(),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: Row(
                        children: [
                          if (!cubit.isFirstVideo())
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => cubit.previousVideo(
                                      context.read<BetterPlayerController?>()),
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
                          if (!cubit.isLastVideo())
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('next'),
                                  style: AppStyles.styleMedium16(context),
                                ),
                                IconButton(
                                  onPressed: () => cubit.nextVideo(
                                      context.read<BetterPlayerController?>()),
                                  icon: Icon(isArabic(context)
                                      ? Iconsax.arrow_circle_left
                                      : Iconsax.arrow_circle_right),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: SizedBox(
                        child: Text(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          'برمجة الاردوينو بواسطة لغة اردوينو المبنيه على لغة c++ و c المهندس علاء',
                          style: AppStyles.styleMedium24(context),
                        ),
                      ),
                    ),
                    TabBar(
                      indicatorColor: Colors.green,
                      labelColor: Theme.of(context).colorScheme.primary,
                      labelStyle: AppStyles.styleMedium18(context),
                      tabs: [
                        Tab(
                          text: AppLocalizations.of(context)!
                              .translate('description'),
                        ),
                        Tab(
                          text: AppLocalizations.of(context)!
                              .translate('comments'),
                        ),
                      ],
                    ),
                    const Expanded(
                      child: TabBarView(
                        children: [
                          ListViewVideoAccessories(),
                          CommentsVideoLesson()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
