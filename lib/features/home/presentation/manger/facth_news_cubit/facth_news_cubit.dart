// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/widget/snackbar.dart';

import 'package:lms/features/home/domain/enitites/news_enity.dart';
import 'package:lms/features/home/domain/use_cases/news_use_case.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'facth_news_state.dart';

class FacthNewsCubit extends HydratedCubit<FacthNewsState>
    with WidgetsBindingObserver {
  final FetchNewsetUseCase fetchNewsetUseCase;
  List<NewsEnity> allNews = [];
  bool hasReachedEnd = false;
  bool isLoadingMore = false;
  bool isInitialLoading = false;
  DateTime? lastSnackBarTime;

  FacthNewsCubit(this.fetchNewsetUseCase) : super(FacthNewsInitial()) {
    WidgetsBinding.instance.addObserver(this);
    _checkConnectivityAndFetch();
  }

  Future<void> refreshNews({BuildContext? context}) async {
    allNews.clear();
    hasReachedEnd = false;
    isLoadingMore = false;
    await fetchNews(skip: 0, forceRefresh: true, context: context);
  }

  Future<void> fetchNews(
      {int skip = 0, bool forceRefresh = false, BuildContext? context}) async {
    if (hasReachedEnd || isLoadingMore) return;

    if (skip == 0 && !forceRefresh) {
      isInitialLoading = true;
      emit(FacthNewsLoading());
    } else {
      isLoadingMore = true;
    }

    if (skip == 0 && !forceRefresh) {
      var box = await Hive.openBox<NewsEnity>('newsCache');
      if (box.isNotEmpty) {
        allNews = box.values.skip(skip * 10).take(10).toList();
        emit(FacthNewsLoaded(allNews));
      }
    }

    var result = await fetchNewsetUseCase.call(skip: skip);
    result.fold(
      (failure) async {
        isInitialLoading = false;
        isLoadingMore = false;

        var box = await Hive.openBox<NewsEnity>('newsCache');
        if (box.isNotEmpty) {
          allNews = box.values.toList();
          emit(FacthNewsLoaded(allNews));
        }

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
      (news) async {
        isInitialLoading = false;
        isLoadingMore = false;
        if (news.length < 10) {
          hasReachedEnd = true;
        }

        if (skip == 0) {
          var box = await Hive.openBox<NewsEnity>('newsCache');
          await box.clear();
          await box.addAll(news);
        }

        for (var item in news) {
          if (!allNews.any((existingNews) => existingNews.idN == item.idN)) {
            allNews.add(item);
          }
        }

        emit(FacthNewsLoaded(allNews));
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
    await refreshNews(context: context);
  }

  @override
  FacthNewsState? fromJson(Map<String, dynamic> json) {
    try {
      final cachedNews =
          (json['news'] as List).map((e) => NewsEnity.fromJson(e)).toList();
      return FacthNewsLoaded(cachedNews);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(FacthNewsState state) {
    if (state is FacthNewsLoaded) {
      return {'news': state.news.map((e) => e.toJson()).toList()};
    }
    return null;
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
