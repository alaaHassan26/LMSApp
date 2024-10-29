import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/features/courses_page/presentation/views/widget/mcq_view_list/custom_item_mcq_listview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../../core/utils/app_router.dart';
import '../../../manger/mcq_cubit/mcq_cubit.dart';
import '../../../manger/mcq_cubit/mcq_state.dart';

class CustomListViewSearchMcq extends StatefulWidget {
  const CustomListViewSearchMcq({super.key});

  @override
  _CustomListViewSearchMcqState createState() =>
      _CustomListViewSearchMcqState();
}

class _CustomListViewSearchMcqState extends State<CustomListViewSearchMcq> {
  @override
  void initState() {
    super.initState();
    // Fetch data after the widget is initialized
    context.read<McqCubit>().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<McqCubit, McqState>(
      builder: (context, state) {
        if (state is McqLoading) {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: isDarkMode ? Colors.white : Colors.black,
              size: 56,
            ),
          );
        } else if (state is McqFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 56),
                const SizedBox(height: 8),
                Text(
                  state.errorMessage,
                  style: AppStyles.styleMedium16(context)
                      .copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<McqCubit>().getCategories();
                  },
                  child: const Text('حاول مجدداً'),
                ),
              ],
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
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: Card(
                    color: isDarkMode ? null : whiteColor,
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
