import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lms/core/Server/Error_Failures.dart';
import 'package:lms/features/courses_page/data/data_sources/courses_remot_data_source.dart';
import 'package:lms/features/courses_page/data/models/courses_model.dart';
import 'package:lms/features/courses_page/data/models/lessons_model.dart';
import 'package:lms/features/courses_page/domain/repo/courses_repo.dart';

class CoursesRepoImpl extends CoursesRepo {
  final CoursesRemotDataSource coursesRemotDataSource;

  CoursesRepoImpl({required this.coursesRemotDataSource});
  @override
  Future<Either<Failure, List<Course>>> getCourses({int skip = 0}) async {
    try {
      List<Course> remotCourses =
          await coursesRemotDataSource.getCourses(skip: skip);
      return right(remotCourses);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<Lesson>>> getLessons(
      {required String categoryId}) async {
    try {
      List<Lesson> remotLessons =
          await coursesRemotDataSource.getLessons(categoryId: categoryId);
      return right(remotLessons);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
