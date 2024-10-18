import 'package:hive_flutter/adapters.dart';
import 'package:lms/cache/cache_helper.dart';
import 'package:lms/core/Server/Api_Dio.dart';

import 'package:lms/features/home/domain/enitites/news_enity.dart';

abstract class HomeRemotDataSource {
  Future<List<NewsEnity>> getNews({int skip = 0});
}

class HomeRemotDataSourceImpl extends HomeRemotDataSource {
  final ApiService apiService;

  HomeRemotDataSourceImpl({required this.apiService});

  @override
  Future<List<NewsEnity>> getNews({int skip = 0}) async {
    var box = await Hive.openBox<NewsEnity>('newsCache');

    String? token = CacheHelper().getData(key: 'saveToken');
    final response = await apiService
        .get('/api/get_news?skip=${skip * 10}&limit=10', token: token);

    final List<NewsEnity> newsList = (response.data['result'] as List)
        .map((newsJson) => NewsEnity.fromJson(newsJson))
        .toList();

    // تحديث الكاش عند skip = 0 أو إضافة البيانات الجديدة فقط
    if (skip == 0) {
      await box.clear(); // مسح الكاش عند الرفريش
      await box.addAll(newsList); // تخزين البيانات الجديدة في الكاش
    } else {
      for (var news in newsList) {
        // التحقق من عدم وجود تكرار
        if (!box.values.any((cachedNews) => cachedNews.idN == news.idN)) {
          await box.add(news); // إضافة فقط الأخبار الجديدة إلى الكاش
        }
      }
    }

    return newsList;
  }
}
