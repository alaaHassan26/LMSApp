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
      child: Image.asset(
        image,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}
