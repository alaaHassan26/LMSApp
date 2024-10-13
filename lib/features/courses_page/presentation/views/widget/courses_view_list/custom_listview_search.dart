import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/features/courses_page/data/models/search_model.dart';
import 'package:lms/features/courses_page/presentation/manger/search_cubit/search_cubit.dart';
import 'package:lms/features/courses_page/presentation/views/widget/custom_item_list_view.dart';
import 'package:lms/features/courses_page/presentation/views/widget/courses_view_list/custom_list_view_courses.dart';

class CustomListViewSearch extends StatelessWidget {
  const CustomListViewSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<SearchCubit, List<SearchModel>>(
        builder: (context, searchResults) {
          if (searchResults.isEmpty) {
            final isSearching = context.read<SearchCubit>().isSearching;
            if (!isSearching) {
              return const CustomListViewCourses();
            } else {
              return Center(
                child: Text(
                    AppLocalizations.of(context)!.translate('no_results_found'),
                    style: AppStyles.styleRegular20(context)),
              );
            }
          } else {
            return ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final course = searchResults[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                  child: Card(
                    elevation: 2,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: CustomItemListView(
                      courseTitle: course.nameTitleCours,
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kListLessonBody);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
