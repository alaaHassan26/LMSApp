import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../cache/cache_helper.dart';
import '../../../../core/Server/Api_Dio.dart';
import '../../../../core/Server/Error_Failures.dart';
import '../models/courses_model.dart';
import '../models/lessons_model.dart';

class CoursesRepository {
   ApiService apiService = ApiService();

  CoursesRepository();

  Future<Either<Failure, List<Course>>> getCourses() async {
    try {
      String? token = CacheHelper().getData(key: 'saveToken') as String?;
      if (token == null) return Left(ServerFailure('Token is null'));

      final response = await apiService.get('/api/get_courses_category', token: token);

      if (response.statusCode == 200) {
        final List<Course> coursesList = (response.data['result'] as List)
            .map((courseJson) => Course.fromJson(courseJson))
            .toList();

        CacheHelper().saveData(
          key: 'cachedCourses',
          value: json.encode(coursesList.map((course) => course.toJson()).toList()),
        );

        return Right(coursesList);
      } else {
        return Left(UnexpectedError());
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }


  Future<Either<Failure, List<Lesson>>> getLessons(String categoryId) async {
    try {
      String? token = CacheHelper().getData(key: 'saveToken') as String?;
      if (token == null) return Left(ServerFailure('Token is null'));

      final response = await apiService.get('/api/get_lessons?category_id=$categoryId', token: token);
print(response);
      if (response.statusCode == 200) {
        final List<Lesson> lessonsList = (response.data['result'] as List)
            .map((lessonJson) => Lesson.fromJson(lessonJson))
            .toList();


        // Optionally cache lessons
        CacheHelper().saveData(
          key: 'cachedLessons',
          value: json.encode(lessonsList.map((lesson) => lesson.toJson()).toList()),
        );

        return Right(lessonsList);
      } else {
        return Left(UnexpectedError());
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      } else {
        print(e);
        return Left(ServerFailure(e.toString()));
      }
    }
  }
}
