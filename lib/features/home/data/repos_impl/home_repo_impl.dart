import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:lms/core/Server/Error_Failures.dart';

import 'package:lms/features/home/data/data_sources/home_remot_data_source.dart';
import 'package:lms/features/home/domain/enitites/news_enity.dart';
import 'package:lms/features/home/domain/repo/home_repo.dart';

class HomeRepoImpl extends HomeRepo {
  final HomeRemotDataSource homeRemotDataSource;

  HomeRepoImpl({required this.homeRemotDataSource});

  @override
  Future<Either<Failure, List<NewsEnity>>> getNews({int skip = 0}) async {
    try {
      List<NewsEnity> remoteNews =
          await homeRemotDataSource.getNews(skip: skip);

      return right(remoteNews);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
