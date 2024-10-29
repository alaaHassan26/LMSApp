import 'package:lms/cache/cache_helper.dart';
import 'package:lms/core/Server/Api_Dio.dart';

import 'package:lms/features/courses_page/data/models/courses_model.dart';
import 'package:lms/features/courses_page/data/models/lessons_model.dart';

abstract class CoursesRemotDataSource {
  Future<List<Course>> getCourses({int skip = 0});
  Future<List<Lesson>> getLessons({required String categoryId});
}

class CoursesRemotDataSourceImpl extends CoursesRemotDataSource {
  final ApiService apiService;

  CoursesRemotDataSourceImpl({required this.apiService});

  @override
  Future<List<Course>> getCourses({int skip = 0}) async {
    String? token = CacheHelper().getData(key: 'saveToken');

    final response = await apiService
        .get('/api/get_courses_category?skip=${skip * 10}', token: token);
    final List<Course> coursesList = (response.data['result'] as List)
        .map((courseJson) => Course.fromJson(courseJson))
        .toList();
    return coursesList;
  }

  @override
  Future<List<Lesson>> getLessons({required String categoryId}) async {
    String? token = CacheHelper().getData(key: 'saveToken') as String?;
    final response = await apiService
        .get('/api/get_lessons?category_id=$categoryId', token: token);
    final List<Lesson> lessonsList = (response.data['result'] as List)
        .map((lessonJson) => Lesson.fromJson(lessonJson))
        .toList();
    return lessonsList;
  }
}
