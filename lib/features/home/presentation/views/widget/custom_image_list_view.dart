import 'package:flutter/material.dart';
import 'package:lms/core/utils/Constatns.dart';
import 'package:lms/core/widget/custom_image.dart';

import 'package:lms/features/home/domain/enitites/news_enity.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomImageListView extends StatefulWidget {
  const CustomImageListView({
    super.key,
    required this.newsEnity,
  });

  final NewsEnity newsEnity;

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
              itemCount: widget.newsEnity.imagesN.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    child: CustomImage(
                      image:
                          '${CS.Api}${widget.newsEnity.imagesN[index].imagePath}',
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
            count: widget.newsEnity.imagesN.length,
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
