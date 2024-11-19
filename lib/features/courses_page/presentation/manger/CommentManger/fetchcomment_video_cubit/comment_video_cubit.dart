// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/widget/snackbar.dart';
import 'package:lms/features/courses_page/data/data_sources/comments/comments_video_local_data_source.dart';
import 'package:lms/features/courses_page/domain/use_case_courses/comments_video_use_case.dart';

import 'package:lms/features/home/data/model/news_comments_model.dart';

import 'comment_video_state.dart';

class CommentVideoCubit extends Cubit<VideoCommentState>
    with WidgetsBindingObserver {
  final FetchCommentsVideoUseCase fetchCommentstUseCase;
  final CommentsVideolocalDataSource commentslocalDataSource;
  List<NewsCommentModel> allComments = [];
  bool hasReachedEnd = false;
  bool isLoadingMore = false;
  bool isInitialLoading = false;
  DateTime? lastSnackBarTime;
  CommentVideoCubit(this.fetchCommentstUseCase, this.commentslocalDataSource)
      : super(VideoCommentInitial()) {
    WidgetsBinding.instance.addObserver(this);
    _initHiveAndFetch();
  }
  Future<void> _initHiveAndFetch() async {
    await _checkConnectivityAndFetch();
  }

  Future<void> refreshNews(
      {BuildContext? context, required String videoId}) async {
    allComments.clear();
    hasReachedEnd = false;
    isLoadingMore = false;
    await getCommentsVideo(
        skip: 0, forceRefresh: true, context: context, videoId: videoId);
  }

  Future<void> getCommentsVideo(
      {int skip = 0,
      required String videoId,
      bool forceRefresh = false,
      BuildContext? context}) async {
    if (hasReachedEnd || isLoadingMore) return;

    if (skip == 0 && !forceRefresh) {
      isInitialLoading = true;
      emit(VideoCommentLoading());
    } else {
      isLoadingMore = true;
    }

    if (skip == 0 && !forceRefresh) {
      emit(VideoCommentFetchSuccess(allComments));
    }

    var result = await fetchCommentstUseCase.call(skip: skip, videoId: videoId);

    result.fold(
      (failure) async {
        isInitialLoading = false;

        final currentTime = DateTime.now();
        if (lastSnackBarTime == null ||
            currentTime.difference(lastSnackBarTime!).inSeconds >= 40) {
          lastSnackBarTime = currentTime;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context != null) {
              CustomSnackbar.showSnackBar(
                  context,
                  failure.err,
                  AppStyles.styleMedium18(context)
                      .copyWith(color: Colors.white));
            }
          });
        }
      },
      (comments) async {
        isInitialLoading = false;
        isLoadingMore = false;

        if (comments.length < 10) {
          hasReachedEnd = true;
        }

        for (var item in comments) {
          if (!allComments.any((existingNews) => existingNews.id == item.id)) {
            allComments.add(item);
          }
        }

        emit(VideoCommentFetchSuccess(allComments));
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state,
      {BuildContext? context}) {
    if (state == AppLifecycleState.resumed) {
      _checkConnectivityAndFetch(context: context);
    }
  }

  Future<void> _checkConnectivityAndFetch({BuildContext? context}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (context != null) {
        CustomSnackbar.showSnackBar(context, 'No internet connection',
            AppStyles.styleMedium18(context).copyWith(color: Colors.white));
      }
      return;
    }
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);

    return super.close();
  }
}
