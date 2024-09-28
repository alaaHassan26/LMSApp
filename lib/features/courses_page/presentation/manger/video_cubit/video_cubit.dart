import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:better_player/better_player.dart';

// الحالة الخاصة بـ Cubit
@immutable
abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final BetterPlayerController betterPlayerController;

  VideoLoaded(this.betterPlayerController);
}

class VideoError extends VideoState {
  final String message;

  VideoError(this.message);
}

// Cubit لإدارة منطق الفيديو
class CustomVideoPlayerCubit extends Cubit<VideoState> {
  CustomVideoPlayerCubit() : super(VideoInitial());

  YoutubeExplode? _youtubeExplode;
  BetterPlayerController? _betterPlayerController;

  Future<void> setupVideoPlayer(String videoUrl) async {
    emit(VideoLoading());

    try {
      // التحقق إذا كان الرابط هو رابط YouTube
      if (videoUrl.contains('youtu')) {

        print('is youtube');
        _youtubeExplode = YoutubeExplode();
        var videoId = VideoId(videoUrl);
                print(videoId);

        var videoStreamInfo =
            await _youtubeExplode!.videos.streamsClient.getManifest(videoId);

        // الحصول على أعلى جودة للفيديو
        videoUrl = videoStreamInfo.muxed.withHighestBitrate().url.toString();

                        print(videoUrl);

      }

      // إذا كان هناك مشغل قديم، قم بتفريغ موارده
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

      emit(VideoLoaded(_betterPlayerController!));
    } catch (e) {

      print(e);
      emit(VideoError("Error loading video: $e"));
    }
  }

  @override
  Future<void> close() {
    // تفريغ موارد الفيديو والـ YoutubeExplode عند إغلاق Cubit
    _betterPlayerController?.dispose();
    _youtubeExplode?.close();
    return super.close();
  }
}
