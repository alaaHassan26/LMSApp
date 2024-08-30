import 'package:flutter/material.dart';
import 'package:lms/features/home/presentation/views/widget/costom_pinned_post.dart';
import 'package:lms/features/home/presentation/views/widget/list_view_home_page.dart';

class HomeBody extends StatelessWidget {
  final VoidCallback onLongPressPost;

  const HomeBody({super.key, required this.onLongPressPost});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomPinnedPost(),
        Expanded(child: ListViewHomePage(onLongPressPost: onLongPressPost)),
      ],
    );
  }
}
