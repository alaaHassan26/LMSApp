// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/widget/snackbar.dart';

import 'package:lms/features/home/data/data_sources/comments/comments_local_data_source.dart';
import 'package:lms/features/home/data/model/news_comments_model.dart';
import 'package:lms/features/home/domain/use_cases/comments_use_case.dart';

import 'comment_state.dart';

class NewsCommentCubit extends Cubit<NewsCommentState>
    with WidgetsBindingObserver {
  final FetchCommentstUseCase fetchCommentstUseCase;
  final CommentslocalDataSource commentslocalDataSource;
  List<NewsCommentModel> allComments = [];
  bool hasReachedEnd = false;
  bool isLoadingMore = false;
  bool isInitialLoading = false;
  DateTime? lastSnackBarTime;
  NewsCommentCubit(this.fetchCommentstUseCase, this.commentslocalDataSource)
      : super(NewsCommentInitial()) {
    WidgetsBinding.instance.addObserver(this);
    _initHiveAndFetch();
  }
  Future<void> _initHiveAndFetch() async {
    await _checkConnectivityAndFetch();
  }

  Future<void> refreshNews(
      {BuildContext? context, required String newsId}) async {
    allComments.clear();
    hasReachedEnd = false;
    isLoadingMore = false;
    await getComments(
        skip: 0, forceRefresh: true, context: context, newsId: newsId);
  }

  Future<void> getComments(
      {int skip = 0,
      required String newsId,
      bool forceRefresh = false,
      BuildContext? context}) async {
    if (hasReachedEnd || isLoadingMore) return;

    if (skip == 0 && !forceRefresh) {
      isInitialLoading = true;
      emit(NewsCommentLoading());
    } else {
      isLoadingMore = true;
    }

    if (skip == 0 && !forceRefresh) {
      emit(NewsCommentFetchSuccess(allComments));
    }

    var result = await fetchCommentstUseCase.call(skip: skip, newsId: newsId);

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

        emit(NewsCommentFetchSuccess(allComments));
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
