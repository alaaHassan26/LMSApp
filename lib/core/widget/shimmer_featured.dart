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

// ignore_for_file: file_names

class ShimmerBestSeller extends StatelessWidget {
  const ShimmerBestSeller({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? Colors.white38 : Colors.black38;
    final highlightColor = isDarkMode ? Colors.white10 : Colors.black12;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.all(12.0),
              child: CommentsPagevShimmer(),
            );
          }),
    );
  }
}

//CommentsPage
class CommentsPagevShimmer extends StatelessWidget {
  const CommentsPagevShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? Colors.white38 : Colors.black38;
    final highlightColor = isDarkMode ? Colors.white10 : Colors.black12;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        children: [
          SizedBox(
            height: 125,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 10,
                        color: Colors.grey[300],
                      ),
                      Container(
                        height: 10,
                        width: MediaQuery.of(context).size.width * 0.3,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.2,
                            color: Colors.grey[300],
                          ),
                          Container(
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class ShimmerNewsItem extends StatelessWidget {
  const ShimmerNewsItem({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? Colors.white38 : Colors.black38;
    final highlightColor = isDarkMode ? Colors.white10 : Colors.black12;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        children: [
          SizedBox(
            height: 125,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 30,
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 10,
                        color: Colors.grey[300],
                      ),
                      Container(
                        height: 10,
                        width: MediaQuery.of(context).size.width * 0.3,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.2,
                            color: Colors.grey[300],
                          ),
                          Container(
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
