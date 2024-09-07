import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerFeaturedList extends StatelessWidget {
  const ShimmerFeaturedList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Shimmer(
      gradient: LinearGradient(
        colors: [
          isDarkMode ? Colors.white38 : Colors.black38,
          isDarkMode ? Colors.white10 : Colors.black12,
          isDarkMode ? Colors.white24 : Colors.black26
        ],
      ),
      period: const Duration(milliseconds: 800),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.blue,
        ),
      ),
    );
  }
}
