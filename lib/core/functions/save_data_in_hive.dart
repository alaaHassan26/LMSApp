import 'package:hive_flutter/hive_flutter.dart';
import 'package:lms/features/home/domain/enitites/news_enity.dart';

void saveDatainHive(List<NewsEnity> newNewsList, String boxName) {
  var box = Hive.box<NewsEnity>(boxName);
  final existingNewsIds = box.values.map((news) => news.idN).toSet();

  final filteredNewsList =
      newNewsList.where((news) => !existingNewsIds.contains(news.idN)).toList();

  if (filteredNewsList.isNotEmpty) {
    List<NewsEnity> existingNews = box.values.toList();
    box.clear();
    box.addAll(filteredNewsList + existingNews);
  }
}














// void saveDatainHive(List<NewsEnity> newNewsList, String boxName) {
//   var box = Hive.box<NewsEnity>(boxName);
//   final existingNewsIds = box.values.map((news) => news.idN).toSet();

//   // فلترة البيانات الجديدة بحيث لا يتم تخزين البيانات المكررة
//   final filteredNewsList =
//       newNewsList.where((news) => !existingNewsIds.contains(news.idN)).toList();

//   // إضافة البيانات المفلترة فقط إلى Hive
//   box.addAll(filteredNewsList);
// }
