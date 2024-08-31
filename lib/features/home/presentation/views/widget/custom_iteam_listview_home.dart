import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/features/home/data/model/home_model.dart';
import 'package:lms/features/home/presentation/views/widget/custom_image_list_view.dart';

import 'package:readmore/readmore.dart';

class CustomItemListViewNewsHome extends StatefulWidget {
  final HomeModel homeModel;
  const CustomItemListViewNewsHome({super.key, required this.homeModel});

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _toggleSelection();
        _showOptionsDialog();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 50,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Card(
                elevation: isSelected ? 16 : 4,
                color: isSelected
                    ? const Color(0xff27DEBF)
                    : Theme.of(context).colorScheme.onPrimary,
                child: Column(
                  children: [
                    if (widget.homeModel.image != null &&
                        widget.homeModel.image!.isNotEmpty) ...[
                      CustomImageListView(
                        homeModel: widget.homeModel,
                      ),
                      const SizedBox(height: 6),
                    ],
                    if (widget.homeModel.title != null) ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: double.infinity,
                            child: ReadMoreText(
                              widget.homeModel.title!,
                              style: AppStyles.styleMedium20(context),
                              trimMode: TrimMode.Line,
                              trimLines: 7,
                              colorClickableText: Colors.pink,
                              trimCollapsedText: AppLocalizations.of(context)!
                                  .translate('showmore'),
                              trimExpandedText: AppLocalizations.of(context)!
                                  .translate('showless'),
                              moreStyle: AppStyles.styleBold16(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (widget.homeModel.pdfUrl != null) ...[
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.kPDFViewerPage,
                              extra: widget.homeModel.pdfUrl!);
                        },
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  GoRouter.of(context).push(
                                      AppRouter.kPDFViewerPage,
                                      extra: widget.homeModel.pdfUrl!);
                                },
                                icon: const Icon(
                                  Icons.picture_as_pdf_sharp,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .translate('view_pdf'),
                                style: AppStyles.styleMedium20(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Divider(),
                    ),
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kCommentsPage);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                const Icon(Iconsax.message_search),
                                const SizedBox(width: 12),
                                TextButton(
                                  onPressed: () {
                                    GoRouter.of(context)
                                        .push(AppRouter.kCommentsPage);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('comment'),
                                    style: AppStyles.styleMedium20(context),
                                  ),
                                )
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  GoRouter.of(context)
                                      .push(AppRouter.kCommentsPage);
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
              ),
            ),
          ),
          Row(
            children: [
              isSelected
                  ? const Icon(Icons.check)
                  : Transform.rotate(
                      angle: isArabic(context) ? 180 : 90,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.reply),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.all(16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.copy),
                title: Text(AppLocalizations.of(context)!.translate('copy')),
                onTap: () {
                  if (widget.homeModel.title != null) {
                    Clipboard.setData(
                      ClipboardData(text: widget.homeModel.title ?? ''),
                    );
                  }
                  Navigator.of(context).pop();
                  _toggleSelection();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: Text(AppLocalizations.of(context)!.translate('cancel')),
                onTap: () {
                  Navigator.of(context).pop();
                  _toggleSelection();
                },
              ),
            ],
          ),
        );
      },
    ).then((_) {
      if (isSelected) {
        _toggleSelection();
      }
    });
  }
}
