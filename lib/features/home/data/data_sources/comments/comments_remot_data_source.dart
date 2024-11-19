import 'package:lms/cache/cache_helper.dart';
import 'package:lms/core/Server/Api_Dio.dart';

import 'package:lms/features/home/data/model/news_comments_model.dart';

abstract class CommentsRemotDataSource {
  Future<List<NewsCommentModel>> getComments(
      {int skip = 0, required String newsId});
}

class CommentsRemotDataSourceImpl extends CommentsRemotDataSource {
  final ApiService apiService;

  CommentsRemotDataSourceImpl({required this.apiService});

  @override
  Future<List<NewsCommentModel>> getComments(
      {int skip = 0, required String newsId}) async {
    // var box = await Hive.openBox<NewsCommentModel>('commentsCache');

    String? token = CacheHelper().getData(key: 'saveToken');
    final response = await apiService.get(
        '/api/get_user_comments?news_id=$newsId&skip=${skip * 10}&limit=10',
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
