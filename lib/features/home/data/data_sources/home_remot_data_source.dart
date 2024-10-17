import 'package:lms/cache/cache_helper.dart';
import 'package:lms/core/Server/Api_Dio.dart';
import 'package:lms/core/functions/save_data_in_hive.dart';
import 'package:lms/core/utils/Constatns.dart';

import 'package:lms/features/home/domain/enitites/news_enity.dart';

abstract class HomeRemotDataSource {
  Future<List<NewsEnity>> getNews({int skip = 0});
}

class HomeRemotDataSourceImpl extends HomeRemotDataSource {
  final ApiService apiService;

  HomeRemotDataSourceImpl({required this.apiService});

  @override
  Future<List<NewsEnity>> getNews({int skip = 0}) async {
    String? token = CacheHelper().getData(key: 'saveToken');

    // نستخدم skip فقط للحصول على البيانات
    final response = await apiService.get(
        '/api/get_news?skip=${skip * 10}&limit=10', // جلب 10 عناصر فقط
        token: token);

    final List<NewsEnity> newsList = (response.data['result'] as List)
        .map((newsJson) => NewsEnity.fromJson(newsJson))
        .toList();

    saveDatainHive(newsList, kNewestBox);
    return newsList;
  }
}
