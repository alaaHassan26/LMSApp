import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/courses_page/data/models/search_model.dart';

class SearchCubit extends Cubit<List<SearchModel>> {
  SearchCubit() : super([]);

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

  void search(String query) {
    if (query.isEmpty) {
      emit([]);
    } else {
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

  void clearSearch() {
    emit([]);
  }
}
