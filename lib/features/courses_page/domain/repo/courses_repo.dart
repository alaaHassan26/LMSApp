import 'package:dartz/dartz.dart';
import 'package:lms/core/Server/Error_Failures.dart';
import 'package:lms/features/courses_page/data/models/courses_model.dart';
import 'package:lms/features/courses_page/data/models/lessons_model.dart';

abstract class CoursesRepo {
  Future<Either<Failure, List<Course>>> getCourses({int skip = 0});
  Future<Either<Failure, List<Lesson>>> getLessons(
      {required String categoryId});
}
