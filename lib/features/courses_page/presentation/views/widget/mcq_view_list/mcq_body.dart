import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/features/courses_page/data/models/search_model.dart';
import 'package:lms/features/courses_page/presentation/manger/search_cubit/search_cubit.dart';
import 'package:lms/features/courses_page/presentation/views/widget/mcq_view_list/custom_listview_search_mcq.dart';
import 'package:lms/features/courses_page/presentation/views/widget/search_and_filter_bar.dart';

class MCQBody extends StatelessWidget {
  const MCQBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //  هنا لست مال البحث الاسئلة
    List<SearchModel> allCourses = [
      const SearchModel(nameTitleCours: 'Flutter Basics'),
      const SearchModel(nameTitleCours: 'Dart Advanced'),
      const SearchModel(nameTitleCours: 'Machine Learning'),
      const SearchModel(nameTitleCours: 'الفيزياء'),
      const SearchModel(nameTitleCours: 'الكيمياء'),
      const SearchModel(nameTitleCours: 'عربي'),
      const SearchModel(nameTitleCours: 'RTS'),
      const SearchModel(nameTitleCours: 'رياضيات'),
    ];
    return Scaffold(
      backgroundColor: isDarkMode ? black38Color : greyColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? black38Color : greyColor,
        title: Text(
          'MCQ Quiz',
          style: AppStyles.styleSemiBold24(context),
        ),
      ),
      body: BlocProvider(
        create: (context) => SearchCubit(allCourses: allCourses),
        child: const Column(
          children: [
            SearchAndFilterBar(),
            CustomListViewSearchMcq(),
          ],
        ),
      ),
    );
  }
}
