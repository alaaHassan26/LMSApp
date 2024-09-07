import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/features/home/data/model/news_model.dart';
import 'package:lms/features/home/presentation/views/widget/custom_image_list_view.dart';
import 'package:lms/features/home/presentation/views/widget/download_pdf_page.dart';
import 'package:intl/intl.dart';

import 'package:readmore/readmore.dart';

class CustomItemListViewNewsHome extends StatefulWidget {
  final NewsModel newsModel;
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
    String date = DateFormat('yyyy / M / d').format(dateTime);
    String time = DateFormat('HH:mm a').format(dateTime);
    return {'date': date, 'time': time};
  }

  @override
  Widget build(BuildContext context) {
    final dateTime = formatDateTime(widget.newsModel.createdAt);

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
          if (widget.newsModel.images.isNotEmpty) ...[
            CustomImageListView(
              newsModel: widget.newsModel,
            ),
            const SizedBox(height: 6),
          ],
          if (widget.newsModel.file != null) ...[
            const SizedBox(height: 6),
            DownloadPdfPage(
              pdfName: widget.newsModel.filename!,
              pdfUrl: widget.newsModel.file!,
            ),
          ],
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ReadMoreText(
                textAlign: TextAlign.justify,
                widget.newsModel.text,
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
          GestureDetector(
            onTap: () {
              GoRouter.of(context).push(AppRouter.kCommentsPage);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            GoRouter.of(context).push(AppRouter.kCommentsPage);
                          },
                          icon: const Icon(Iconsax.message_search)),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).push(AppRouter.kCommentsPage);
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
                        GoRouter.of(context).push(AppRouter.kCommentsPage);
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
