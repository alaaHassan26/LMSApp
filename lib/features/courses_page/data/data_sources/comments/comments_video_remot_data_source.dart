import 'package:lms/cache/cache_helper.dart';
import 'package:lms/core/Server/Api_Dio.dart';

import 'package:lms/features/home/data/model/news_comments_model.dart';

abstract class CommentsVideoRemotDataSource {
  Future<List<NewsCommentModel>> getCommentsVideo(
      {int skip = 0, required String videoId});
}

class CommentsVideoRemotDataSourceImpl extends CommentsVideoRemotDataSource {
  final ApiService apiService;

  CommentsVideoRemotDataSourceImpl({required this.apiService});

  @override
  Future<List<NewsCommentModel>> getCommentsVideo(
      {int skip = 0, required String videoId}) async {
    // var box = await Hive.openBox<NewsCommentModel>('commentsCache');

    String? token = CacheHelper().getData(key: 'saveToken');
    final response = await apiService.get(
        '/api/get_user_lessons_comments?lessons_id=$videoId&skip=${skip * 10}&limit=10',
        token: token);

    final List<NewsCommentModel> commentsList =
        (response.data['result'] as List)
            .map((commentJson) => NewsCommentModel.fromJson(commentJson))
            .toList();

    // // تحديث الكاش عند skip = 0 أو إضافة البيانات الجديدة فقط
    // await saveDataCommentsinHive(skip, box, commentsList);

    return commentsList;
  }
}
