import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_localiizations.dart';

import 'package:lms/core/utils/appstyles.dart';

import 'package:lms/core/widget/download_pdf_page.dart';
import 'package:intl/intl.dart';
import 'package:lms/features/home/domain/enitites/news_enity.dart';

import 'package:readmore/readmore.dart';

class CustomItemVideoAccessoriesListView extends StatefulWidget {
  final NewsEnity newsModel;
  const CustomItemVideoAccessoriesListView(
      {super.key, required this.newsModel});

  @override
  State<StatefulWidget> createState() =>
      _CustomItemVideoAccessoriesListViewState();
}

class _CustomItemVideoAccessoriesListViewState
    extends State<CustomItemVideoAccessoriesListView> {
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
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
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
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(
              height: 32,
            ),
          )
        ],
      ),
    );
  }
}
