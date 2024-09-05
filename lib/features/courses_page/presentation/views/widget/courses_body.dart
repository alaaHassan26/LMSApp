import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lms/features/courses_page/presentation/manger/search_cubit/search_cubit.dart';

import 'package:lms/features/courses_page/presentation/views/widget/custom_listview_search.dart';
import 'package:lms/features/courses_page/presentation/views/widget/search_and_filter_bar.dart';

class CourcsesBody extends StatelessWidget {
  const CourcsesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: const Column(
        children: [
          SearchAndFilterBar(),
          CustomListViewSearch(),
        ],
      ),
    );
  }
}
