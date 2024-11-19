import 'package:hive_flutter/hive_flutter.dart';
import 'package:lms/features/home/data/model/news_comments_model.dart';

abstract class CommentsVideolocalDataSource {
  List<NewsCommentModel> getCommentsVideo(
      {int skip = 0, required String newsId});
}

class CommentsVideolocalDataSourceImpl extends CommentsVideolocalDataSource {
  @override
  List<NewsCommentModel> getCommentsVideo(
      {int skip = 0, required String newsId}) {
    int startIndex = skip * 10;
    int endIndex = startIndex + 10;

    var box = Hive.box<NewsCommentModel>('commentsCache');
    int length = box.values.length;

    if (startIndex >= length) {
      return [];
    }

    endIndex = endIndex > length ? length : endIndex;
    return box.values.toList().sublist(startIndex, endIndex);
  }
}
