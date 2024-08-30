import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage(
      {super.key,
      required this.width,
      required this.height,
      required this.image});
  final double width;
  final double height;
  final String image;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(6)),
      child: Image.asset(
        image,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}
