import 'package:dartz/dartz.dart';
import 'package:lms/core/Server/Error_Failures.dart';

import 'package:lms/features/courses_page/data/models/lessons_model.dart';
import 'package:lms/features/courses_page/domain/repo/courses_repo.dart';

class FetchLessonUseCase {
  final CoursesRepo coursesRepo;

  FetchLessonUseCase({required this.coursesRepo});

  Future<Either<Failure, List<Lesson>>> lesson({required String categoryId}) {
    return coursesRepo.getLessons(categoryId: categoryId);
  }
}
