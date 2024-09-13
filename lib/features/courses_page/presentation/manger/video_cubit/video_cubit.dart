import 'package:better_player/better_player.dart';
import 'package:bloc/bloc.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoCubit extends Cubit<int> {
  final List<String> videoUrls;

  VideoCubit(this.videoUrls) : super(0);

  void nextVideo(BetterPlayerController? currentController) {
    if (state < videoUrls.length - 1) {
      currentController?.dispose();
      emit(state + 1);
    }
  }

  void previousVideo(BetterPlayerController? currentController) {
    if (state > 0) {
      currentController?.dispose();
      emit(state - 1);
    }
  }

  String getCurrentVideoUrl() {
    return videoUrls[state];
  }

  Future<String?> getYouTubeVideoUrl(String youtubeUrl) async {
    var yt = YoutubeExplode();
    try {
      var video = await yt.videos.get(youtubeUrl);
      var manifest = await yt.videos.streamsClient.getManifest(video.id);
      var streamInfo = manifest.muxed.bestQuality;
      return streamInfo.url.toString();
    } catch (e) {
      print("Error fetching YouTube URL: $e");
      return null;
    } finally {
      yt.close();
    }
  }

  Future<String> getVideoUrl() async {
    String currentUrl = getCurrentVideoUrl();
    if (currentUrl.contains('youtube.com') || currentUrl.contains('youtu.be')) {
      return await getYouTubeVideoUrl(currentUrl) ?? currentUrl;
    } else {
      return currentUrl;
    }
  }

  bool isFirstVideo() {
    return state == 0;
  }

  bool isLastVideo() {
    return state == videoUrls.length - 1;
  }
}
