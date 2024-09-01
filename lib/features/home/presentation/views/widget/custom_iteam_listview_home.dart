import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';

import 'package:lms/features/home/data/model/home_model.dart';

import 'package:lms/features/home/presentation/views/widget/custom_image_list_view.dart';
import 'package:lms/features/home/presentation/views/widget/download_pdf_page.dart';

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
                    child: SizedBox(
                      width: double.infinity,
                      child: ReadMoreText(
                        widget.homeModel.title!,
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
                if (widget.homeModel.pdfUrl != null) ...[
                  const SizedBox(height: 6),
                  DownloadPdfPage(
                    pdfName: widget.homeModel.namePdf!,
                    pdfUrl: widget.homeModel.pdfUrl!,
                  ),
                ],
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 120),
                  child: Divider(),
                ),
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push(AppRouter.kCommentsPage);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Divider(
                    height: 26,
                  ),
                )
              ],
            ),
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
