import 'package:hive_flutter/hive_flutter.dart';
import 'package:lms/core/utils/Constatns.dart';
import 'package:lms/features/home/domain/enitites/news_enity.dart';

abstract class HomelocalDataSource {
  List<NewsEnity> getNews({int skip = 0});
}

class HomelocalDataSourceImpl extends HomelocalDataSource {
  @override
  List<NewsEnity> getNews({int skip = 0}) {
    int startIndex = skip * 10;
    int endIndex = startIndex + 10;

    var box = Hive.box<NewsEnity>(kNewestBox);
    int length = box.values.length;

    if (startIndex >= length) {
      return [];
    }

    endIndex = endIndex > length ? length : endIndex;
    return box.values.toList().sublist(startIndex, endIndex);
  }
}
