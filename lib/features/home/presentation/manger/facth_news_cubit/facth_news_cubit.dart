// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/widget/snackbar.dart';
import 'package:lms/features/home/data/data_sources/home_local_data_source.dart';
import 'package:lms/features/home/domain/enitites/news_enity.dart';
import 'package:lms/features/home/domain/use_cases/news_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'facth_news_state.dart';

class FacthNewsCubit extends Cubit<FacthNewsState> with WidgetsBindingObserver {
  final FetchNewsetUseCase fetchNewsetUseCase;
  final HomelocalDataSource homelocalDataSource;

  List<NewsEnity> allNews = [];
  bool hasReachedEnd = false;
  bool isLoadingMore = false;
  bool isInitialLoading = false;
  DateTime? lastSnackBarTime;

  FacthNewsCubit(this.fetchNewsetUseCase, this.homelocalDataSource)
      : super(FacthNewsInitial()) {
    WidgetsBinding.instance.addObserver(this);
    _initHiveAndFetch();
  }

  Future<void> _initHiveAndFetch() async {
    await _checkConnectivityAndFetch();
  }

  Future<void> refreshNews({BuildContext? context}) async {
    allNews.clear();
    hasReachedEnd = false;
    isLoadingMore = false;
    await fetchNews(skip: 0, forceRefresh: true, context: context);
  }

  Future<void> fetchNews(
      {int skip = 0, bool forceRefresh = false, BuildContext? context}) async {
    final Box<NewsEnity> newsBox = await Hive.openBox<NewsEnity>('newsCache');
    if (hasReachedEnd || isLoadingMore) return;

    if (skip == 0 && !forceRefresh) {
      isInitialLoading = true;
      emit(FacthNewsLoading());
    } else {
      isLoadingMore = true;
    }

    if (skip == 0 && !forceRefresh && newsBox.isNotEmpty) {
      emit(FacthNewsLoaded(allNews));
    }

    var result = await fetchNewsetUseCase.call(skip: skip);
    result.fold(
      (failure) async {
        isInitialLoading = false;
        isLoadingMore = false;

        var box = await Hive.openBox<NewsEnity>('newsCache');
        if (box.isNotEmpty) {
          final paginatedNews = homelocalDataSource.getNews(skip: skip);
          if (paginatedNews.length < 10) {
            hasReachedEnd = true;
          }

          allNews.addAll(paginatedNews);
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
          await newsBox.clear();
          await newsBox.addAll(news);
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
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);

    return super.close();
  }
}
