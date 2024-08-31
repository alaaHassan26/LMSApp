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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: isDarkMode ? Colors.black12 : Colors.white,
      elevation: .4,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.75,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.homeModel.image?.length ?? 1,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.999,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImage(
                      image: widget.homeModel.image![index],
                      width: MediaQuery.of(context).size.width * 0.999,
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
              dotColor: Colors.grey,
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
