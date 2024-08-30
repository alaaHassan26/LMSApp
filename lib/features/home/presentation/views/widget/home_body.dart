import 'package:flutter/material.dart';
import 'package:lms/features/home/presentation/views/widget/costom_pinned_post.dart';
import 'package:lms/features/home/presentation/views/widget/list_view_home_page.dart';

class HomeBody extends StatelessWidget {
  final VoidCallback onLongPressPost;

  const HomeBody({super.key, required this.onLongPressPost});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const CustomPinnedPost(),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListViewHomePage(onLongPressPost: onLongPressPost),
          )),
        ],
      ),
    );
  }
}
