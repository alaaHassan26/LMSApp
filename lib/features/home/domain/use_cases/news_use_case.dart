import 'package:dartz/dartz.dart';
import 'package:lms/core/Server/Error_Failures.dart';
import 'package:lms/features/home/domain/enitites/news_enity.dart';
import 'package:lms/features/home/domain/repo/home_repo.dart';

class FetchNewsetUseCase {
  final HomeRepo homeRepo;

  FetchNewsetUseCase(this.homeRepo);
  Future<Either<Failure, List<NewsEnity>>> call({int skip = 0}) {
    return homeRepo.getNews(skip: skip);
  }
}
