import 'package:flutter/material.dart';
import 'package:lms/core/widget/shimmer_featured.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.width,
    required this.height,
    required this.image,
    this.borderRadius,
  });

  final double width;
  final double height;
  final String image;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(0),
      child: Stack(
        children: [
          Image.network(
            image,
            width: width,
            height: height,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) {
                return child;
              } else {
                return const ShimmerFeaturedList();
              }
            },
            errorBuilder: (context, error, stackTrace) => const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  size: 32,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Image Not Available',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
