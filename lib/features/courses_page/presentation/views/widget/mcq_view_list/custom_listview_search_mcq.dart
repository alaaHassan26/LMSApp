import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/features/courses_page/presentation/views/widget/mcq_view_list/custom_item_mcq_listview.dart';

import '../../../../../../core/utils/app_router.dart';
import '../../../manger/mcq_cubit/mcq_cubit.dart';
import '../../../manger/mcq_cubit/mcq_state.dart';

class CustomListViewSearchMcq extends StatefulWidget {
  const CustomListViewSearchMcq({super.key});

  @override
  _CustomListViewSearchMcqState createState() => _CustomListViewSearchMcqState();
}

class _CustomListViewSearchMcqState extends State<CustomListViewSearchMcq> {
  @override
  void initState() {
    super.initState();
    // Fetch data after the widget is initialized
    context.read<McqCubit>().mcqCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<McqCubit, McqState>(
      builder: (context, state) {
        if (state is McqLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is McqFailure) {
          return Center(
            child: Text(
              state.errorMessage,
              style: AppStyles.styleRegular20(context),
            ),
          );
        } else if (state is McqSuccess) {
          final categories = state.categories;

          if (categories.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          return Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Card(
                    elevation: 2,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: CustomItemMcqListView(
                      courseTitle: category.title,
                      courseNumber: 'عدد الاسئلة 5',
                      onTap: () {


                        print(state.categories[index].title);

                        print(state.categories[index].id);
GoRouter.of(context).push(
  AppRouter.kStartMcqPage,
  extra: {
    'questions': state.categories[index].id,
    'title': state.categories[index].title, 
  },
);

                      },
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
