import 'package:hive_flutter/hive_flutter.dart';
import 'package:lms/features/home/domain/enitites/news_enity.dart';

Future<void> saveDatainHive(
    int skip, Box<NewsEnity> box, List<NewsEnity> newsList) async {
  // تحديث الكاش عند skip = 0 أو إضافة البيانات الجديدة فقط
  if (skip == 0) {
    await box.clear(); // مسح الكاش عند الرفريش
    await box.addAll(newsList); // تخزين البيانات الجديدة في الكاش
  } else {
    // إنشاء Set يحتوي على معرفات الأخبار المخزنة بالفعل
    Set<String> cachedIds =
        box.values.map((cachedNews) => cachedNews.idN).toSet();

    for (var news in newsList) {
      // التحقق من عدم وجود تكرار باستخدام Set
      if (!cachedIds.contains(news.idN)) {
        await box.add(news); // إضافة فقط الأخبار الجديدة إلى الكاش
        cachedIds.add(news.idN); // إضافة المعرف إلى الـ Set
      }
    }
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
