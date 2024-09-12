import 'package:better_player/better_player.dart';
import 'package:bloc/bloc.dart';

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

  bool isFirstVideo() {
    return state == 0;
  }

  bool isLastVideo() {
    return state == videoUrls.length - 1;
  }
}
