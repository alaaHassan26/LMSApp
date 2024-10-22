import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/features/home/domain/enitites/news_enity.dart';

import 'package:lms/features/home/presentation/views/widget/custom_image_list_view.dart';
import 'package:lms/core/widget/download_pdf_page.dart';
import 'package:intl/intl.dart';

import 'package:readmore/readmore.dart';

class CustomItemListViewNewsHome extends StatefulWidget {
  final NewsEnity newsEnity;
  const CustomItemListViewNewsHome({super.key, required this.newsEnity});

  @override
  State<StatefulWidget> createState() => _CustomItemListViewNewsHomeState();
}

class _CustomItemListViewNewsHomeState extends State<CustomItemListViewNewsHome>
    with AutomaticKeepAliveClientMixin {
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
    super.build(context); // Important to call super.build
    final dateTime = formatDateTime(widget.newsEnity.createdAtN);

    return GestureDetector(
      onLongPress: () {
        _toggleSelection();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
          if (widget.newsEnity.imagesN.isNotEmpty) ...[
            GestureDetector(
              onTap: () {
                GoRouter.of(context)
                    .push(AppRouter.kImageView, extra: widget.newsEnity);
              },
              child: CustomImageListView(
                newsEnity: widget.newsEnity,
              ),
            ),
            const SizedBox(height: 6),
          ],
          if (widget.newsEnity.fileN != null) ...[
            const SizedBox(height: 6),
            DownloadPdfPage(
              pdfName: widget.newsEnity.filenameN!,
              pdfUrl: widget.newsEnity.fileN!,
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ReadMoreText(
                textAlign: TextAlign.justify,
                widget.newsEnity.textN,
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
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              GoRouter.of(context).push(
                AppRouter.kCommentsPage,
                extra: widget.newsEnity.idN,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            GoRouter.of(context).push(
                              AppRouter.kCommentsPage,
                              extra: widget.newsEnity.idN,
                            );
                          },
                          icon: const Icon(Iconsax.message_search)),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).push(
                            AppRouter.kCommentsPage,
                            extra: widget.newsEnity.idN,
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
                          extra: widget.newsEnity.idN,
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

  @override
  bool get wantKeepAlive => true; // This keeps the widget alive
}
