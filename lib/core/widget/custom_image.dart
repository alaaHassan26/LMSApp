import 'package:cached_network_image/cached_network_image.dart';
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

  // URL for the fallback image
  final String fallbackImageUrl = 'https://images.pexels.com/photos/28216688/pexels-photo-28216688/free-photo-of-autumn-camping.png';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(0),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: image,
            width: width,
            height: height,
            fit: BoxFit.cover,
            placeholder: (context, url) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: const ShimmerFeaturedList(),
            ),
            errorWidget: (context, url, error) => CachedNetworkImage(
              imageUrl: fallbackImageUrl, // Show the fallback image on error
              width: width,
              height: height,
              fit: BoxFit.cover,
              placeholder: (context, url) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: const ShimmerFeaturedList(),
              ),
              errorWidget: (context, url, error) => const Column(
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
                    'Fallback Image Not Available',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
