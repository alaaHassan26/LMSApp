import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/courses_page/data/models/search_model.dart';
import 'package:lms/features/courses_page/presentation/manger/search_cubit/search_cubit.dart';
import 'package:lms/features/courses_page/presentation/views/widget/custom_item_list_view.dart';
import 'package:lms/features/courses_page/presentation/views/widget/custom_list_view_courses.dart';

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
            return const CustomListViewCourses();
          } else {
            return ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final course = searchResults[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Card(
                    elevation: 2,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: CustomItemListView(
                      courseTitle: course.nameTitleCours,
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
