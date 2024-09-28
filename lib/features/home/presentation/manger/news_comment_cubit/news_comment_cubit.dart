import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/home/data/model/news_comments_model.dart';
import '../../../../../cache/cache_helper.dart';
import '../../../data/Repo/news_repo.dart';
import 'news_comment_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  NewsRepository newsRepository = NewsRepository();

  CommentsCubit() : super(CommentsInitial());

  Future<void> fetchComments(String newsId) async {
    emit(CommentsLoading());

    final eitherResponse = await newsRepository.getComments(newsId);

    eitherResponse.fold(
      (failure) => emit(CommentsError(failure.err)),
      (commentsList) {
        emit(CommentsLoaded(commentsList));
      },
    );
  }

  Future<void> addComment(String newsId, String content) async {
    final currentState = state;
    if (currentState is! CommentsLoaded) return;

    // ابو حسين هنا تعليق مؤقت محليًا


    var cachedUserName = CacheHelper().getData(key: 'user_name');
    var userImage = CacheHelper().getData(key: 'user_image');



    final tempComment = NewsCommentModel(
      id: DateTime.now().toString(), // معرف مؤقت
      userId: 'currentUserId', // معرف المستخدم الحالي
      newsId: newsId,
      isProfessor: 0,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: null,
      user: UserModel(
        id: 'currentUserId',
        
        name: cachedUserName,
        email: 'user@example.com',
        image: '$userImage',
        userType: 0,
        accountStatus: 1,
        randomCode: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      children: [],
    );

    // إضافة التعليق الموقت إلى القائمة
    final updatedComments =
        List<NewsCommentModel>.from(currentState.commentsList)
          ..insert(0, tempComment);
    emit(CommentsLoaded(updatedComments));

    // استدعاء API لإضافة التعليق
    final eitherResponse = await newsRepository.addComment(newsId, content);

    eitherResponse.fold(
      (failure) {
        // هنا انت شوف شلون تسوي الخطا
        // إذا فشلت الإضافة، يمكنك عرض رسالة خطأ مع إبقاء التعليق المؤقت
        emit(CommentsError(failure.err));
        emit(CommentsLoaded(updatedComments));
      },
      (newCommentFromApi) {
        // إذا نجحت الإضافة، استبدل التعليق المؤقت بالبيانات الحقيقية
        final finalComments = updatedComments.map((comment) {
          if (comment.id == tempComment.id) {
            // استبدال التعليق المؤقت بالبيانات من الـ API
            return newCommentFromApi;
          }
          return comment;
        }).toList();

        emit(CommentsLoaded(finalComments));
        emit(CommentAdded());
      },
    );
  }

  Future<void> replayComment(
      String newsId, String content, String parentCommentId) async {
    emit(CommentsLoading());
    final eitherResponse =
        await newsRepository.addReplay(newsId, content, parentCommentId);

    eitherResponse.fold(
      (failure) => emit(CommentsError(failure.err)),
      (_) {
        fetchComments(newsId);
        emit(CommentReplied());
      },
    );
  }
}
