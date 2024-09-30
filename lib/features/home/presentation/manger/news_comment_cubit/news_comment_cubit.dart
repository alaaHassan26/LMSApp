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

  Future<void> replyToComment(
      String newsId, String content, String parentCommentId) async {
    final currentState = state;
    if (currentState is! CommentsLoaded) return;

    // 1. إنشاء الرد المؤقت لعرضه في واجهة المستخدم.
    final tempReply = NewsCommentModel(
      id: DateTime.now().toString(),
      userId: 'currentUserId',
      newsId: newsId,
      parentCommentId: parentCommentId,
      isProfessor: 0,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: null,
      user: UserModel(
        id: 'currentUserId',
        name: CacheHelper().getData(key: 'user_name'),
        email: 'user@example.com',
        image: CacheHelper().getData(key: 'user_image'),
        userType: 0,
        accountStatus: 1,
        randomCode: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      children: [],
    );

    // 2. تحديث التعليقات المحلية بإضافة الرد المؤقت في المكان المناسب.
    final updatedComments = _addReplyToComments(
      currentState.commentsList,
      parentCommentId,
      tempReply,
    );

    emit(CommentsLoaded(updatedComments));

    // 3. استدعاء API لإضافة الرد الجديد.
    final eitherResponse =
        await newsRepository.addReplay(newsId, content, parentCommentId);

    eitherResponse.fold(
      (failure) {
        // التعامل مع الخطأ وإعادة الحالة السابقة
        emit(CommentsError(failure.err));
        emit(CommentsLoaded(updatedComments)); // إعادة الحالة السابقة بعد الخطأ
      },
      (newReplyFromApi) {
        // 4. استبدال الرد المؤقت بالرد الفعلي من API.
        final finalComments = _replaceTempReplyWithActualReply(
          updatedComments,
          tempReply.id,
          newReplyFromApi,
        );

        emit(CommentsLoaded(finalComments));
        emit(CommentReplied());
      },
    );
  }

  /// دالة لمساعدة: لإضافة الرد إلى التعليقات في الشجرة الهرمية بشكل متداخل.
  List<NewsCommentModel> _addReplyToComments(
    List<NewsCommentModel> commentsList,
    String parentCommentId,
    NewsCommentModel tempReply,
  ) {
    return commentsList.map((comment) {
      if (comment.id == parentCommentId) {
        // إذا كان هذا هو التعليق الأب، قم بإضافة الرد إلى children.
        return comment.copyWith(children: [...?comment.children, tempReply]);
      } else if (comment.children != null) {
        // استدعاء الدالة بشكل متكرر إذا كان التعليق يحتوي على ردود فرعية.
        final updatedChildren =
            _addReplyToComments(comment.children!, parentCommentId, tempReply);
        return comment.copyWith(children: updatedChildren);
      }
      return comment;
    }).toList();
  }

  /// دالة لمساعدة: لاستبدال الرد المؤقت بالرد الفعلي من API.
  List<NewsCommentModel> _replaceTempReplyWithActualReply(
    List<NewsCommentModel> commentsList,
    String tempReplyId,
    NewsCommentModel newReply,
  ) {
    return commentsList.map((comment) {
      if (comment.children != null) {
        // استبدال الرد المؤقت إذا وجد في children.
        final updatedChildren = comment.children!.map((child) {
          if (child.id == tempReplyId) {
            return newReply; // استبدال الرد المؤقت.
          } else if (child.children != null) {
            // متابعة البحث داخل الشجرة.
            return child.copyWith(
                children: _replaceTempReplyWithActualReply(
                    child.children!, tempReplyId, newReply));
          }
          return child;
        }).toList();

        return comment.copyWith(children: updatedChildren);
      }
      return comment;
    }).toList();
  }
}
