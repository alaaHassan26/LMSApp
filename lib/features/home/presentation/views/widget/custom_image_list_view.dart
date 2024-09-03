import 'package:flutter/material.dart';
import 'package:lms/core/widget/custom_image.dart';
import 'package:lms/features/home/data/model/home_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomImageListView extends StatefulWidget {
  const CustomImageListView({
    super.key,
    required this.homeModel,
  });

  final HomeModel homeModel;

  @override
  State<CustomImageListView> createState() => _CustomImageListViewState();
}

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
            height: MediaQuery.of(context).size.width * 0.75,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.homeModel.image?.length ?? 1,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    child: CustomImage(
                      image: widget.homeModel.image![index],
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.6,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          SmoothPageIndicator(
            controller: _pageController,
            count: widget.homeModel.image?.length ?? 1,
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
