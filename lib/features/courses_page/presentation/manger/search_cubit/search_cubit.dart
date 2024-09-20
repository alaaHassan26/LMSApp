import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/courses_page/data/models/search_model.dart';

class SearchCubit extends Cubit<List<SearchModel>> {
  SearchCubit({required this.allCourses}) : super([]);

  final List<SearchModel> allCourses;

  bool isSearching = false;

  void search(String query) {
    isSearching = query.isNotEmpty;
    query = query.trim();
    if (query.isEmpty) {
      isSearching = false;
      emit([]);
    } else {
      isSearching = true;
      List<SearchModel> results = allCourses.where((course) {
        return course.nameTitleCours
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();

      results.sort((a, b) {
        return a.nameTitleCours.toLowerCase().startsWith(query.toLowerCase())
            ? -1
            : 1;
      });

      emit(results);
    }
  }
}
