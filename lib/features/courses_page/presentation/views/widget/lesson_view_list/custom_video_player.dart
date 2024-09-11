import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();
//ابو حسين هنا تخلي رابط الفيديو ويجب ان يكون اما بصيغة
//m3u8
// او mpd
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8');

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
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(controller: _betterPlayerController),
    );
  }
}
