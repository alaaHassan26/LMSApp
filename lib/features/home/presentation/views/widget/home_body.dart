import 'package:flutter/material.dart';
import 'package:lms/features/home/presentation/views/widget/costom_pinned_post.dart';
import 'package:lms/features/home/presentation/views/widget/list_view_home_page.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CustomPinnedPost(),
        Expanded(child: ListViewHomePage()),
      ],
    );
  }
}
