import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/Constatns.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';

import 'package:lms/core/widget/custom_image.dart';
import 'package:lms/core/widget/download_pdf_page.dart';
import 'package:lms/features/home/domain/enitites/news_enity.dart';

import 'package:lms/features/home/presentation/manger/cubit/cubit/facth_news_cubit.dart';

import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TestNews extends StatefulWidget {
  const TestNews({super.key});

  @override
  State<TestNews> createState() => _TestNewsState();
}

class _TestNewsState extends State<TestNews> {
  late final ScrollController _scrollController;
  var skip = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<FacthNewsCubit>();
    _loadLocalNews();
    _updateNewsInBackground();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadLocalNews() async {
    final cubit = context.read<FacthNewsCubit>();
    cubit.fetchNews(skip: skip);
  }

  Future<void> _updateNewsInBackground() async {
    final cubit = context.read<FacthNewsCubit>();
    cubit.updateNewsInBackground();
  }

  void _onScroll() async {
    var currentPosition = _scrollController.position.pixels;
    var maxScrollLength = _scrollController.position.maxScrollExtent;
    if (currentPosition >= 0.7 * maxScrollLength) {
      if (!isLoading) {
        isLoading = true;
        skip++;
        await BlocProvider.of<FacthNewsCubit>(context).fetchNews(skip: skip);
        isLoading = false;
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? black38Color : greyColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? black38Color : whiteColor,
        title: Text(
          AppLocalizations.of(context)!.translate('news'),
          style: AppStyles.styleSemiBold34(context),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.notification),
          ),
        ],
      ),
      body: BlocBuilder<FacthNewsCubit, FacthNewsState>(
        builder: (context, state) {
          final cubit = context.read<FacthNewsCubit>();
          final newsList = cubit.allNews;

          if (state is FacthNewsLoading && newsList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FacthNewsLoaded || state is FacthNewsLoading) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: newsList.length + (cubit.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < newsList.length) {
                  return Card(
                    color: isDarkMode ? null : Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 0,
                    child: CustomItemListViewNewsHome(
                      newsModel: newsList[index],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          } else if (state is FacthNewsError) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

class CustomItemListViewNewsHome extends StatefulWidget {
  final NewsEnity newsModel;
  const CustomItemListViewNewsHome({super.key, required this.newsModel});

  @override
  State<StatefulWidget> createState() => _CustomItemListViewNewsHomeState();
}

class _CustomItemListViewNewsHomeState
    extends State<CustomItemListViewNewsHome> {
  bool isSelected = false;

  void _toggleSelection() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  Map<String, String> formatDateTime(DateTime dateTime) {
    bool arabic = isArabic(context);

    String timeFormat = arabic ? 'hh:mm a' : 'hh:mm a';
    String time = DateFormat(timeFormat).format(dateTime);

    if (arabic) {
      time = time.replaceAll('AM', 'ص').replaceAll('PM', 'م');
    }

    String date = arabic
        ? DateFormat('yyyy / M / d', 'ar').format(dateTime)
        : DateFormat('yyyy / M / d').format(dateTime);

    return {'date': date, 'time': time};
  }

  @override
  Widget build(BuildContext context) {
    final dateTime = formatDateTime(widget.newsModel.createdAtN);

    return GestureDetector(
      onLongPress: () {
        _toggleSelection();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Iconsax.timer_start,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      dateTime['time']!,
                      style: AppStyles.styleMedium16(context),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      dateTime['date']!,
                      style: AppStyles.styleMedium16(context),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    const Icon(
                      Iconsax.calendar,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (widget.newsModel.imagesN.isNotEmpty) ...[
            GestureDetector(
              onTap: () {
                GoRouter.of(context)
                    .push(AppRouter.kImageView, extra: widget.newsModel);
              },
              child: CustomImageListView(
                newsModel: widget.newsModel,
              ),
            ),
            const SizedBox(height: 6),
          ],
          if (widget.newsModel.fileN != null) ...[
            const SizedBox(height: 6),
            DownloadPdfPage(
              pdfName: widget.newsModel.filenameN!,
              pdfUrl: widget.newsModel.fileN!,
            ),
          ],
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ReadMoreText(
                textAlign: TextAlign.justify,
                widget.newsModel.textN,
                style: AppStyles.styleMedium20(context),
                trimMode: TrimMode.Line,
                trimLines: 7,
                colorClickableText: Colors.pink,
                trimCollapsedText:
                    AppLocalizations.of(context)!.translate('showmore'),
                trimExpandedText:
                    AppLocalizations.of(context)!.translate('showless'),
                moreStyle: AppStyles.styleBold16(context),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Divider(),
          ),
          InkWell(
            onTap: () {
              print(widget.newsModel.idN);
              GoRouter.of(context).push(
                AppRouter.kCommentsPage,
                extra: widget.newsModel.idN,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            GoRouter.of(context).push(
                              AppRouter.kCommentsPage,
                              extra: widget.newsModel.idN,
                            );
                          },
                          icon: const Icon(Iconsax.message_search)),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).push(
                            AppRouter.kCommentsPage,
                            extra: widget.newsModel.idN,
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.translate('comment'),
                          style: AppStyles.styleMedium20(context),
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        GoRouter.of(context).push(
                          AppRouter.kCommentsPage,
                          extra: widget.newsModel.idN,
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomImageListView extends StatefulWidget {
  const CustomImageListView({
    super.key,
    required this.newsModel,
  });

  final NewsEnity newsModel;

  @override
  State<CustomImageListView> createState() => _CustomImageListViewState();
}

@override
class _CustomImageListViewState extends State<CustomImageListView> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      elevation: 0,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 1,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.newsModel.imagesN.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    child: CustomImage(
                      image:
                          '${CS.Api}${widget.newsModel.imagesN[index].imagePath}',
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          SmoothPageIndicator(
            controller: _pageController,
            count: widget.newsModel.imagesN.length,
            effect: const WormEffect(
              dotHeight: 8,
              dotWidth: 8,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}

// import 'package:better_player/better_player.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lms/core/manger/text_vlad.dart';

// // حزمة الكيوبت لإدارة حالة تحميل الفيديو

// class VideoPlayerScreen extends StatefulWidget {
//   const VideoPlayerScreen({super.key});

//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late BetterPlayerController _betterPlayerController;
//   final String videoUrl =
//       "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4";
//   bool _isVideoDownloaded = false;
//   String? _localVideoPath;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _checkIfDownloaded();
//   }

//   // التحقق مما إذا كان الفيديو قد تم تنزيله مسبقًا
//   Future<void> _checkIfDownloaded() async {
//     final cubit = context.read<VideoDownloadCubit>();
//     await cubit.checkIfDownloaded(videoUrl);
//     final state = cubit.state;

//     if (state is VideoLoaded) {
//       _localVideoPath = state.filePath;
//       _isVideoDownloaded = true;
//       _initializeVideo(_localVideoPath); // تشغيل الفيديو المحلي مباشرة
//     } else {
//       _initializeVideo(); // محاولة تشغيل الفيديو عبر الإنترنت
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   // تهيئة مشغل الفيديو
//   void _initializeVideo([String? filePath]) {
//     BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
//       filePath != null
//           ? BetterPlayerDataSourceType.file
//           : BetterPlayerDataSourceType.network,
//       filePath ?? videoUrl,
//     );
//     _betterPlayerController = BetterPlayerController(
//       BetterPlayerConfiguration(
//         aspectRatio: 16 / 9,
//         autoPlay: true,
//         looping: true,
//         errorBuilder: (context, errorMessage) {
//           return Center(child: Text('Error: $errorMessage'));
//         },
//       ),
//       betterPlayerDataSource: betterPlayerDataSource,
//     );
//   }

//   // زر تنزيل الفيديو
//   Widget _buildDownloadButton() {
//     return BlocBuilder<VideoDownloadCubit, VideoState>(
//       builder: (context, state) {
//         if (state is VideoInitial && !_isVideoDownloaded) {
//           return ElevatedButton(
//             onPressed: () {
//               context.read<VideoDownloadCubit>().downloadAndSaveVideo(videoUrl);
//             },
//             child: const Text('Download Video'),
//           );
//         } else if (state is VideoLoading) {
//           return const CircularProgressIndicator();
//         } else if (state is VideoProgress) {
//           return Text('Downloading... ${state.progress}%');
//         } else if (state is VideoLoaded || _isVideoDownloaded) {
//           return ElevatedButton(
//             onPressed: () {
//               _initializeVideo(
//                   state is VideoLoaded ? state.filePath : _localVideoPath);
//               setState(() {});
//             },
//             child: const Text('Play Downloaded Video'),
//           );
//         } else if (state is VideoError) {
//           return Text('Error: ${state.message}');
//         } else {
//           return const SizedBox.shrink();
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _betterPlayerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Better Player Demo'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 AspectRatio(
//                   aspectRatio: 16 / 9,
//                   child: BetterPlayer(
//                     controller: _betterPlayerController,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildDownloadButton(),
//               ],
//             ),
//     );
//   }
// }
