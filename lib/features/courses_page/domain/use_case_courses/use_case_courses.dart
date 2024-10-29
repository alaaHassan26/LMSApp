import 'package:dartz/dartz.dart';
import 'package:lms/core/Server/Error_Failures.dart';
import 'package:lms/features/courses_page/data/models/courses_model.dart';

import 'package:lms/features/courses_page/domain/repo/courses_repo.dart';

class FetchCoursestUseCase {
  final CoursesRepo coursesRepo;

  FetchCoursestUseCase({required this.coursesRepo});
  Future<Either<Failure, List<Course>>> coures({int skip = 0}) {
    return coursesRepo.getCourses(skip: skip);
  }
}
