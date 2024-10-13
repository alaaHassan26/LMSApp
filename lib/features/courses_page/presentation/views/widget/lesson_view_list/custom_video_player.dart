import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/courses_page/presentation/manger/video_cubit/video_cubit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomVideoPlayer extends StatelessWidget {
  final String videoUrl;

  const CustomVideoPlayer({required this.videoUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomVideoPlayerCubit()..setupVideoPlayer(videoUrl),
      child: BlocBuilder<CustomVideoPlayerCubit, VideoState>(
        buildWhen: (previous, current) =>
            previous != current, // تحسين الأداء بمنع إعادة البناء غير الضرورية
        builder: (context, state) {
          print(videoUrl);
          if (state is VideoLoading) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: Theme.of(context).colorScheme.onPrimary,
                size: 46,
              ),
            );
          } else if (state is VideoLoaded) {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: state.betterPlayerController),
            );
          } else if (state is VideoError) {
            return Center(child: Text(state.message));
          } else {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: Theme.of(context).colorScheme.onPrimary,
                size: 46,
              ),
            );
          }
        },
      ),
    );
  }
}
