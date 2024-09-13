import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:lms/features/courses_page/presentation/manger/video_cubit/video_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const CustomVideoPlayer({required this.videoUrl, super.key});

  @override
  State<StatefulWidget> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  BetterPlayerController? _betterPlayerController;

  @override
  void initState() {
    super.initState();
    _setupVideoPlayer();
  }

  void _setupVideoPlayer() async {
    final videoUrl = await context.read<VideoCubit>().getVideoUrl();
    _betterPlayerController?.dispose();

    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrl,
    );

    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableSkips: true,
          skipBackIcon: Icons.replay_10,
          skipForwardIcon: Icons.forward_10,
          enableMute: true,
          enableFullscreen: true,
          enablePlaybackSpeed: true,
          showControlsOnInitialize: true,
          enableProgressBar: true,
          enableProgressText: true,
        ),
        autoPlay: true,
        looping: false,
        fullScreenByDefault: false,
        fit: BoxFit.contain,
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );
    setState(() {});
  }

  @override
  void didUpdateWidget(CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _betterPlayerController?.dispose();
      _setupVideoPlayer();
    }
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _betterPlayerController != null
          ? BetterPlayer(controller: _betterPlayerController!)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
