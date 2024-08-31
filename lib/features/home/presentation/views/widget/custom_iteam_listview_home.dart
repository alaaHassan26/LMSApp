import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/widget/custom_image.dart';
import 'package:lms/features/home/data/model/home_model.dart';
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

  void _showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          contentPadding: const EdgeInsets.all(12),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.copy),
                  title: Text(AppLocalizations.of(context)!.translate('copy')),
                  onTap: () {
                    // قم بوضع منطق النسخ هنا
                    Navigator.of(context).pop();
                    _toggleSelection(); // لإعادة تعيين الظلال
                  },
                ),
                // ListTile(
                //   leading: const Icon(Icons.share),
                //   title: Text(AppLocalizations.of(context)!.translate('share')),
                //   onTap: () {
                //     // قم بوضع منطق المشاركة هنا
                //     Navigator.of(context).pop();
                //     _toggleSelection(); // لإعادة تعيين الظلال
                //   },
                // ),
                ListTile(
                  leading: const Icon(Icons.push_pin),
                  title: Text(AppLocalizations.of(context)!.translate('pin')),
                  onTap: () {
                    // قم بوضع منطق التثبيت هنا
                    Navigator.of(context).pop();
                    _toggleSelection(); // لإعادة تعيين الظلال
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title:
                      Text(AppLocalizations.of(context)!.translate('cancel')),
                  onTap: () {
                    Navigator.of(context).pop();
                    _toggleSelection();
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      if (isSelected) {
        _toggleSelection();
      }
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
                color: Theme.of(context).colorScheme.onPrimary,
                child: Column(
                  children: [
                    if (widget.homeModel.image != null) ...[
                      CustomImage(
                        image: widget.homeModel.image!,
                        width: MediaQuery.of(context).size.width * 0.999,
                        height: MediaQuery.of(context).size.width * 0.6,
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              const Icon(Iconsax.message_search),
                              const SizedBox(width: 12),
                              Text(
                                AppLocalizations.of(context)!
                                    .translate('comment'),
                                style: AppStyles.styleMedium20(context),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Transform.rotate(
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
}
