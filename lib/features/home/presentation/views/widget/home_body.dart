import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/home/presentation/views/widget/list_view_home_page.dart';

import '../../manger/news_cubit/news_cubit.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit()..fetchNews(),
      child: const Column(
        children: [
          Expanded(child: ListViewHomePage()),
        ],
      ),
    );
  }
}
