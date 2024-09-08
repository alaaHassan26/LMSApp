import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/features/home/data/model/news_model.dart';
import 'package:lms/features/home/presentation/views/widget/custom_image_list_view.dart';
import 'package:readmore/readmore.dart';

class ImageView extends StatefulWidget {
  const ImageView({super.key, required this.newsModel});
  final NewsModel newsModel;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool showInfo = false;
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
    final dateTime = formatDateTime(widget.newsModel.createdAt);

    return SafeArea(
      child: Scaffold(
        backgroundColor: black38Color,
        body: GestureDetector(
          onTap: () {
            setState(() {
              showInfo = !showInfo;
            });
          },
          child: Stack(
            children: [
              // الصورة في منتصف الشاشة
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageListView(
                    newsModel: widget.newsModel,
                  ),
                ],
              ),

              showInfo
                  ? CustomViewImageHeader(
                      showInfo: showInfo, dateTime: dateTime)
                  : const SizedBox(),

              showInfo
                  ? CustomViewImageBottom(widget: widget)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomViewImageBottom extends StatelessWidget {
  const CustomViewImageBottom({
    super.key,
    required this.widget,
  });

  final ImageView widget;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.23,
      minChildSize: 0.1,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController, // التمرير للنص
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Icon(
                  Icons.remove,
                  size: 26,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ReadMoreText(
                      textAlign: TextAlign.justify,
                      widget.newsModel.text,
                      style: AppStyles.styleMedium20(context)
                          .copyWith(color: Colors.white),
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
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomViewImageHeader extends StatelessWidget {
  const CustomViewImageHeader({
    super.key,
    required this.showInfo,
    required this.dateTime,
  });

  final bool showInfo;
  final Map<String, String> dateTime;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: showInfo ? 0 : -100,
      left: 0,
      right: 0,
      duration: const Duration(milliseconds: 300),
      child: Container(
          color: Colors.black.withOpacity(0.6),
          padding: const EdgeInsets.all(10),
          child: ListTile(
            leading: IconButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            title: Text(
              AppLocalizations.of(context)!.translate('news'),
              style: AppStyles.styleMedium24(context)
                  .copyWith(color: Colors.white),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Iconsax.timer_start,
                      size: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      dateTime['time']!,
                      style: AppStyles.styleMedium16(context)
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      dateTime['date']!,
                      style: AppStyles.styleMedium16(context)
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    const Icon(
                      Iconsax.calendar,
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Iconsax.menu,
                  color: Colors.white,
                )),
          )),
    );
  }
}
