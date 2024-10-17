import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lms/core/Server/Error_Failures.dart';
import 'package:lms/core/functions/save_data_in_hive.dart';
import 'package:lms/core/utils/Constatns.dart';
import 'package:lms/features/home/data/data_sources/home_local_data_source.dart';
import 'package:lms/features/home/data/data_sources/home_remot_data_source.dart';
import 'package:lms/features/home/domain/enitites/news_enity.dart';
import 'package:lms/features/home/domain/repo/home_repo.dart';

class HomeRepoImpl extends HomeRepo {
  final HomeRemotDataSource homeRemotDataSource;
  final HomelocalDataSource homelocalDataSource;

  HomeRepoImpl(
      {required this.homelocalDataSource, required this.homeRemotDataSource});

  @override
  Future<Either<Failure, List<NewsEnity>>> getNews({int skip = 0}) async {
    try {
      List<NewsEnity> localNews = homelocalDataSource.getNews(skip: skip);

      if (localNews.isNotEmpty && !shouldUpdateData()) {
        return right(localNews);
      }

      List<NewsEnity> remoteNews =
          await homeRemotDataSource.getNews(skip: skip);

      if (remoteNews.isNotEmpty) {
        saveDatainHive(remoteNews, kNewestBox);
        saveLastUpdateTime();
      }

      return right(remoteNews);
    } catch (e) {
      List<NewsEnity> localNews = homelocalDataSource.getNews(skip: skip);

      if (localNews.isNotEmpty) {
        return right(localNews);
      }
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}

void saveLastUpdateTime() {
  var box = Hive.box('settings');
  box.put('lastUpdateTime', DateTime.now().toIso8601String());
}

bool shouldUpdateData() {
  var box = Hive.box('settings');
  String? lastUpdateTime = box.get('lastUpdateTime');

  if (lastUpdateTime == null) {
    return true;
  }

  DateTime lastUpdate = DateTime.parse(lastUpdateTime);
  return DateTime.now().difference(lastUpdate).inSeconds > 20;
}
