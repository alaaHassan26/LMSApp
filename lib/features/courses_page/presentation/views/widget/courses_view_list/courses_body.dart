import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/courses_page/data/models/search_model.dart';

import 'package:lms/features/courses_page/presentation/manger/search_cubit/search_cubit.dart';

import 'package:lms/features/courses_page/presentation/views/widget/courses_view_list/custom_listview_search.dart';
import 'package:lms/features/courses_page/presentation/views/widget/search_and_filter_bar.dart';

class CourcsesBody extends StatelessWidget {
  const CourcsesBody({super.key});

  @override
  Widget build(BuildContext context) {
    // الديوث هنا لست مال البحث الكورسات
    List<SearchModel> allCourses = [
      const SearchModel(nameTitleCours: 'Flutter Basics'),
      const SearchModel(nameTitleCours: 'Dart Advanced'),
      const SearchModel(nameTitleCours: 'Machine Learning'),
      const SearchModel(nameTitleCours: 'علاء'),
      const SearchModel(nameTitleCours: 'علي عبد'),
      const SearchModel(nameTitleCours: 'علاء حسن'),
      const SearchModel(nameTitleCours: 'حسن'),
      const SearchModel(nameTitleCours: 'علي حسين'),
    ];
    return BlocProvider(
      create: (context) => SearchCubit(allCourses: allCourses),
      child: const Column(
        children: [
          SearchAndFilterBar(),
          CustomListViewSearch(),
        ],
      ),
    );
  }
}
