import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/manger/text_vlad.dart';

// حزمة الكيوبت لإدارة حالة تحميل الفيديو

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late BetterPlayerController _betterPlayerController;
  final String videoUrl =
      "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4";
  bool _isVideoDownloaded = false;
  String? _localVideoPath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfDownloaded();
  }

  // التحقق مما إذا كان الفيديو قد تم تنزيله مسبقًا
  Future<void> _checkIfDownloaded() async {
    final cubit = context.read<VideoDownloadCubit>();
    await cubit.checkIfDownloaded(videoUrl);
    final state = cubit.state;

    if (state is VideoLoaded) {
      _localVideoPath = state.filePath;
      _isVideoDownloaded = true;
      _initializeVideo(_localVideoPath); // تشغيل الفيديو المحلي مباشرة
    } else {
      _initializeVideo(); // محاولة تشغيل الفيديو عبر الإنترنت
    }
    setState(() {
      _isLoading = false;
    });
  }

  // تهيئة مشغل الفيديو
  void _initializeVideo([String? filePath]) {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      filePath != null
          ? BetterPlayerDataSourceType.file
          : BetterPlayerDataSourceType.network,
      filePath ?? videoUrl,
    );
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: true,
        errorBuilder: (context, errorMessage) {
          return Center(child: Text('Error: $errorMessage'));
        },
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );
  }

  // زر تنزيل الفيديو
  Widget _buildDownloadButton() {
    return BlocBuilder<VideoDownloadCubit, VideoState>(
      builder: (context, state) {
        if (state is VideoInitial && !_isVideoDownloaded) {
          return ElevatedButton(
            onPressed: () {
              context.read<VideoDownloadCubit>().downloadAndSaveVideo(videoUrl);
            },
            child: const Text('Download Video'),
          );
        } else if (state is VideoLoading) {
          return const CircularProgressIndicator();
        } else if (state is VideoProgress) {
          return Text('Downloading... ${state.progress}%');
        } else if (state is VideoLoaded || _isVideoDownloaded) {
          return ElevatedButton(
            onPressed: () {
              _initializeVideo(
                  state is VideoLoaded ? state.filePath : _localVideoPath);
              setState(() {});
            },
            child: const Text('Play Downloaded Video'),
          );
        } else if (state is VideoError) {
          return Text('Error: ${state.message}');
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Better Player Demo'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BetterPlayer(
                    controller: _betterPlayerController,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDownloadButton(),
              ],
            ),
    );
  }
}
