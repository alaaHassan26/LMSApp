import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

// حالة إدارة الفيديو
abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoProgress extends VideoState {
  final int progress;
  VideoProgress(this.progress);
}

class VideoLoaded extends VideoState {
  final String filePath;
  VideoLoaded(this.filePath);
}

class VideoError extends VideoState {
  final String message;
  VideoError(this.message);
}

// Cubit لتحميل الفيديو
class VideoDownloadCubit extends Cubit<VideoState> {
  VideoDownloadCubit() : super(VideoInitial());

  // تحقق مما إذا تم تنزيل الفيديو مسبقاً
  Future<void> checkIfDownloaded(String videoUrl) async {
    if (await isVideoDownloaded(videoUrl)) {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = videoUrl.hashCode.toString();
      final file = File('${dir.path}/$fileName.mp4');
      emit(VideoLoaded(file.path));
    }
  }

  // تحقق مما إذا كان الفيديو موجوداً
  Future<bool> isVideoDownloaded(String videoUrl) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = videoUrl.hashCode.toString();
    final file = File('${dir.path}/$fileName.mp4');
    return file.existsSync();
  }

  // تنزيل وحفظ الفيديو
  Future<void> downloadAndSaveVideo(String videoUrl) async {
    emit(VideoLoading());
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = videoUrl.hashCode.toString();
      final file = File('${dir.path}/$fileName.mp4');

      if (!file.existsSync()) {
        emit(VideoProgress(0));

        await Dio().download(
          videoUrl,
          file.path,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              int progress = (received / total * 100).toInt();
              emit(VideoProgress(progress));
            }
          },
        );
      }

      await Future.delayed(const Duration(milliseconds: 250));

      emit(VideoLoaded(file.path));
    } catch (e) {
      emit(VideoError('Error downloading video: $e'));
    }
  }

  // حذف الفيديو
  Future<void> deleteVideo(String videoUrl) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = videoUrl.hashCode.toString();
      final file = File('${dir.path}/$fileName.mp4');

      if (file.existsSync()) {
        await file.delete();
        emit(VideoInitial());
      }
    } catch (e) {
      emit(VideoError('Error deleting video: $e'));
    }
  }
}
