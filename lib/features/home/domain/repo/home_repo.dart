import 'package:dartz/dartz.dart';
import 'package:lms/core/Server/Error_Failures.dart';
import 'package:lms/features/home/domain/enitites/news_enity.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<NewsEnity>>> getNews({int skip = 0});
}
